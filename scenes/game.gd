extends MarginContainer

onready var map: GridContainer = $parts/centered/map
var units = null

var sound = preload("res://resources/sounds/main scene (mp3cut.net).mp3")
var TileScene = preload("res://utils/tile.tscn")
var _animate_queue: Array
var _hints_enabled: bool = true

func _ready():
	_animate_queue = []
	_hints_enabled = true
	_prepare_battlefield()
	GameState.connect("active_spells_changed", self, 'show_spells')
	_fetch_queue()
	$parts/root_buttons.visible = GameState.god_mode
	GameState.start_new_game(self)
	render_exited_amount()
	prepare_spell_hints()
#	set_hints_visibility(true)
	call_deferred('set_hints_visibility', not GameState.god_mode)
	$parts/texture/main_hint.call_deferred("rescale")
	set_spells_lock(true)
	_on_change_selected_unit_type(0)
	call_deferred('_spawn_drag_hint')
	AudioManager.play_this(sound)
	
	
	
func set_hints_visibility(is_visible: bool):
	_hints_enabled = is_visible
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
	
	var spell_children = []
	for child in $parts/spells.get_children():
		child.visible = false
		if child is Spell:
			spell_children.append(child)
		
	var selected_spells = [Rand.choice(spell_children)]
	spell_children.erase(selected_spells[0])
	selected_spells.append(Rand.choice(spell_children))
	for spell in selected_spells:
		spell.visible = true
	
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

func set_spells_lock(locked: bool):
	for child in $parts/spells.get_children():
		if child is Spell:
			child.is_enabled = not locked
	
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
#
#var exited = 0
#
#func increase_exited_amount(unit):
#	exited += 1
#	render_exited_amount()
onready var race_to_color_code: Dictionary = {
	UnitUtils.Race.Undead: "#a0aaaaff",
	UnitUtils.Race.Demon: "#a0ffaaaa",
	UnitUtils.Race.Greenskin: "#a0aaffaa",
}

func render_exited_amount():
	var exited_text = ""
	for race in race_to_color_code.keys():
		var exited_amount = GameState.unit_race_to_amount_exit.get(race, 0)
		var color_code = race_to_color_code[race]
		print(race, ": ", exited_amount, ", ", color_code)
#		var color_code = race_to_color_code.get(race, "#a0ffffff")
		if exited_text:
			exited_text += "/"
		exited_text += "[color=" + color_code + "]" + str(exited_amount) + "[/color]"
	$parts/score/capacity_value.text = str(GameState.castle_capacity)
	$parts/score/exited_value.bbcode_text = str(exited_text)
	$parts/score/exited_value.get_child(0).modulate.a = 0
	

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

func _on_spawn_full_pressed():
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

const DragHint = preload("res://scenes/drag_hint.tscn")

func _spawn_drag_hint():
	if not _hints_enabled:
		return
	print('spawn_drag_hint')
	var hint = DragHint.instance()
	var map_rect = $parts/centered.get_rect()
	var spells_rect = $parts/spells.get_rect()
	hint.position = spells_rect.position + spells_rect.size / 2
	$parts.add_child(hint)
	hint.move_to(map_rect.position + map_rect.size / 2, $Timer.wait_time)
