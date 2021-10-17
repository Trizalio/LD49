extends MarginContainer

onready var map: GridContainer = $parts/centered/map
var units = null

onready var TileScene = preload("res://utils/tile.tscn")


# TODO: get from map
onready var separation: Vector2 = Vector2(4, 4)
var _animate_queue = []
#var base_time_step = 0.1
#var duration_deviation_fraction = 0.2
#var min_time_step = base_time_step * (1 - duration_deviation_fraction)
#var max_time_step = base_time_step * (1 + duration_deviation_fraction)

func _ready():
	_prepare_battlefield()
	GameState.connect("active_spells_changed", self, 'show_spells')
	GameState.connect("unit_exited", self, 'render_exited_amount')
	_fetch_queue()
	$parts/root_buttons.visible = GameState.god_mode
	render_exited_amount()
	GameState.game = self
	GameState.start_new_game()
	prepare_spell_hints()
#	set_hints_visibility(true)
	call_deferred('set_hints_visibility', not GameState.god_mode)
	$parts/texture/main_hint.call_deferred("rescale")
	set_spells_lock(true)
	_on_change_selected_unit_type(0)
	
func set_hints_visibility(is_visible: bool):
	for hint in get_tree().get_nodes_in_group("hints"):
		hint.visible = is_visible
		if is_visible:
			hint.rescale()
	
	if not is_visible:
		return
		
	var spells_panel = $parts/spells
	var max_x = 0
	for child in spells_panel.get_children():
		if child is Spell and child.visible:
			max_x = max(max_x, child.get_rect().end.x)
	$parts/spells/hint.allowed_width = spells_panel.rect_size.x - max_x
	
	$parts/centered/hint.allowed_width = $parts/centered.rect_size.x - map.get_rect().end.x

func prepare_spell_hints():
	for child in $parts/spells.get_children():
		if child is Spell:
			add_hint_to_control(child, 'show_spell_hint', [child])

func show_spells(spells: Array):
	if GameState.god_mode:
		return
		
	for child in $parts/spells.get_children():
		child.visible = spells.find(child.get_name()) != -1
	
	call_deferred('set_hints_visibility', GameState.turn_number == 1 and not GameState.god_mode)
#	set_hints_visibility(false)
#
#func _get_duration():
#	return Rand.float_in_range(min_time_step, max_time_step)

func set_tiles_modulate(positions: Array, color: Color):
	for pos in positions:
		var tile: Tile = map.get_node(str(pos.x) + str(pos.y))
		tile.self_modulate = color

var very_bad_color = Color(0.7, 0.4, 0.4, 1)
var bad_color = Color(0.8, 0.6, 0.6, 1)
var good_color = Color(0.6, 0.8, 0.6, 1) # Color(0.8, 0.9, 0.8, 1)
var very_good_color = Color(0.4, 0.7, 0.4, 1)
var default_color = Color(1, 1, 1, 0.59)

func render_spell_targets(targets: Spell.SpellTargets = null):
	var all_position = []
	for y in range(Matrix.matrix_height):
		for x in range(Matrix.matrix_width):
			all_position.append(Vector2(x, y))
	set_tiles_modulate(all_position, default_color)
	if targets != null:
		set_tiles_modulate(targets.very_bad_positions, very_bad_color)
		set_tiles_modulate(targets.bad_positions, bad_color)
		set_tiles_modulate(targets.good_positions, good_color)
		set_tiles_modulate(targets.very_good_positions, very_good_color)

func _prepare_battlefield():
	map.set_columns(Matrix.matrix_width)
	for y in range(Matrix.matrix_height - 1, -1, -1):
		for x in range(Matrix.matrix_width - 1, -1, -1):
			var new_tile = TileScene.instance()
			map.add_child(new_tile)
			new_tile.set_name(str(x) + str(y))
			add_hint_to_control(new_tile, 'show_unit_hint', [Vector2(x, y)])
			new_tile.connect('mouse_exited', self, 'render_spell_targets')
			
	units = Node2D.new()
	units.set_name('units')
	map.add_child(units)
	
func add_hint_to_control(target: Control, method_name: String, args):
	var timer = Timer.new()
	timer.wait_time = 0.3
	timer.one_shot = true
	target.add_child(timer)
	target.connect("mouse_entered", timer, "start")
	target.connect("mouse_exited", timer, "stop")
	timer.connect("timeout", self, method_name, args)
	
func show_spell_hint(spell: Spell) -> void:
	print('show_spell_hint')
	$parts/texture/main_hint.show_spell_hint(spell)
	
func show_unit_hint(position: Vector2) -> void:
	print('show_unit_hint')
	$parts/texture/main_hint.show_unit_hint(Matrix.get_cell(position).unit)

func put_into_animate_queue(arg_1, arg_2, arg_3, arg_4=true):
	print("put_into_animate_queue(", arg_1, ", ", arg_2, ", ", arg_3, ", ", arg_4, ")")
	_animate_queue.append([arg_1, arg_2, arg_3, arg_4])

func set_spells_lock(boolean: bool):
	$parts/spells.modulate = Color(1, 1, 1, 0.5 + 0.5 * int(!boolean))
	
	
func _fetch_queue():
	var wait = true
	if _animate_queue.size() > 0:
		set_spells_lock(true)
		var task = _animate_queue.pop_front()
		print('task: ', task)
		wait = task[3]
		task[0].call("animate_" + task[1], task[2])
#		call(task[0], task[1], task[2], task[3])
	else:
		set_spells_lock(false)
	if wait:
		yield(get_tree().create_timer(GameState.base_time_step), "timeout")
	call_deferred("_fetch_queue")

func matrix_to_map(matrix_position: Vector2) -> Vector2:
	var node_name = str(matrix_position.x) + str(matrix_position.y)
	var tile: TextureRect = map.get_node(node_name)
	var position = tile.get_position()
	var cell_size = tile.get_rect().size
	return position + cell_size / 2
	
func append_unit(unit: Unit):
	units.add_child(unit)

var exited = 0

func increase_exited_amount(unit):
	exited += 1
	render_exited_amount()

func render_exited_amount():
	$parts/score/capacity_value.text = str(GameState.castle_capacity)
	$parts/score/exited_value.text = str(exited)

var spawn_position = Vector2(0, 0)
func _change_x(change: int):
	spawn_position.x = clamp(spawn_position.x + change, 0, Matrix.matrix_width - 1)
	$parts/root_buttons/x.text = str(spawn_position.x)
func _change_y(change: int):
	spawn_position.y = clamp(spawn_position.y + change, 0, Matrix.matrix_height - 1)
	$parts/root_buttons/y.text = str(spawn_position.y)
	
onready var selected_race_index = 0
onready var selected_race = UnitsGenerator.faction_to_units.keys()[selected_race_index]
onready var selected_unit_index = 0
onready var selected_unit = UnitsGenerator.faction_to_units[selected_race][selected_unit_index]

func _on_change_selected_unit_type(shift: int):
	selected_unit_index += shift
	if selected_unit_index >= len(UnitsGenerator.faction_to_units[selected_race]):
		print('change to next race')
		selected_unit_index = 0
		selected_race_index += 1
		if selected_race_index >= len(UnitsGenerator.faction_to_units):
			print('start from race list start')
			selected_race_index = 0
			
	if selected_unit_index < 0:
		print('change to last race')
		selected_race_index -= 1
		if selected_race_index < 0:
			print('start from race_list_end')
			selected_race_index = len(UnitsGenerator.faction_to_units) - 1
		selected_unit_index = len(UnitsGenerator.faction_to_units[UnitsGenerator.faction_to_units.keys()[selected_race_index]]) - 1
	
	selected_race = UnitsGenerator.faction_to_units.keys()[selected_race_index]
	selected_unit = UnitsGenerator.faction_to_units[selected_race][selected_unit_index]
#	print(selected_unit)
	var path: String = selected_unit.resource_path
	var unit_type_name = path.split("/")[-1].split(".")[0]
	$parts/root_buttons/unit_type.text = unit_type_name

func _on_next_turn_pressed():
	GameState._next_turn()


func _on_spawn_all_pressed():
	for y in range(Matrix.matrix_height - 1, -1, -1):
		for x in range(Matrix.matrix_width - 1, -1, -1):
			spawn_position = Vector2(x, y)
			var cell = Matrix.get_cell(spawn_position)
			if cell.unit != null:
				return
			var new_unit = selected_unit.instance()
			Matrix.enter_matrix(spawn_position, new_unit, false)

func _on_spawn_imp_pressed():
	var cell = Matrix.get_cell(spawn_position)
	if cell.unit != null:
		return
	var new_unit = selected_unit.instance()
	Matrix.enter_matrix(spawn_position, new_unit, false)
