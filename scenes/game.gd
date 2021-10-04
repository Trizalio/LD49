extends MarginContainer

onready var map: GridContainer = $parts/centered/map
var units = null

onready var Tile = preload("res://utils/tile.tscn")


# TODO: get from map
onready var separation: Vector2 = Vector2(4, 4)
var _animate_queue = []
var base_time_step = 0.1
var duration_deviation_fraction = 0.2
var min_time_step = base_time_step * (1 - duration_deviation_fraction)
var max_time_step = base_time_step * (1 + duration_deviation_fraction)

func _ready():
	_prepare_battlefield()
	Matrix.connect("unit_entered", self, 'put_into_animate_queue', [null, null, null, "unit_entered"])
	Matrix.connect("unit_exited", self, 'put_into_animate_queue',  [null, null, null, "unit_exited"])
	Matrix.connect("unit_moved", self, 'put_into_animate_queue', [null, "unit_moved"])
	Matrix.connect("unit_replaced", self, 'put_into_animate_queue',  [null, null, "unit_replaced"])
	Matrix.connect("unit_interacted", self, 'put_into_animate_queue', [null,"unit_interacted"])
	Matrix.connect("damage_taken", self, 'put_into_animate_queue', [null, null, null,"damage_taken"])
	Matrix.connect("unit_status_changed", self, 'put_into_animate_queue', ["unit_status_changed"])
	Matrix.connect("cell_interacted", self, 'put_into_animate_queue', [null, "cell_interacted"])
	GameState.connect("active_spells_changed", self, 'show_spells')
	_fetch_queue()
	if GameState.god_mode:
		$parts/next_turn.visible = true
	GameState.start_new_game()

func show_spells(spells: Array):
	if GameState.god_mode:
		return
		
	for child in $parts/spells.get_children():
		child.visible = spells.find(child.get_name()) != -1
	
func _get_duration():
	return Rand.randf_range(min_time_step, max_time_step)
	

func _prepare_battlefield():
	map.set_columns(Matrix.matrix_width)
	for y in range(Matrix.matrix_height - 1, -1, -1):
		for x in range(Matrix.matrix_width - 1, -1, -1):
			var new_tile = Tile.instance()
			map.add_child(new_tile)
			new_tile.set_name(str(x) + str(y))
			new_tile.connect('hover', self, 'show_hint', [Vector2(x, y)])
			
	units = Node2D.new()
	units.set_name('units')
	map.add_child(units)
	
func show_hint(position: Vector2) -> void:
	print('show_hint')
	$hint.show_unit_hint(Matrix.get_cell(position).unit)
#	$hint.visible = true

func put_into_animate_queue(arg_1, arg_2 ,arg_3, arg_4, method_name):
	_animate_queue.append([method_name, arg_1, arg_2, arg_3, arg_4])
	pass
	
func _fetch_queue():
	if _animate_queue.size() > 0:
		var task = _animate_queue.pop_front()
		call(task[0], task[1], task[2], task[3],  task[4])
	yield(get_tree().create_timer(duration_deviation_fraction), "timeout")
	_fetch_queue()
	
func unit_status_changed(unit, action, inst, from):
	print("changing unit status: " + str(unit) + "action " + str(action) + "inst: " + str(inst))
	if unit:
		if from:
			if unit is Unit and from is Unit:
				if unit != from:
					if action != "stunned":
						_attack_unit_to_target(from, unit)
		
		unit.call(action, inst)
	
func matrix_to_map(matrix_position: Vector2) -> Vector2:
	var node_name = str(matrix_position.x) + str(matrix_position.y)
	var tile: TextureRect = map.get_node(node_name)
	var position = tile.get_position()
	var cell_size = tile.get_rect().size
	return position + cell_size / 2

func unit_entered(unit_matrix_position: Vector2, __  ,___ ,____):
	print('GUI.unit_appeared(position=' + str(unit_matrix_position) + ')')
	var unit: Node2D = Matrix.get_cell(unit_matrix_position).unit
	units.add_child(unit)
	var final_position: Vector2 = matrix_to_map(unit_matrix_position)
	var delta = matrix_to_map(unit_matrix_position + Vector2(0, 1)) - final_position
	var start_position: Vector2 = final_position - delta
	unit.set_position(start_position)
	unit.set_modulate(Color(1, 1, 1, 0))
	var duration = _get_duration()
	Animator.animate(unit, "position", final_position, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	Animator.animate(unit, "modulate", Color(1, 1, 1, 1), duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)

func unit_moved(__, position_to: Vector2, unit: Unit, ___ ):
	print('GUI.unit_moved(unit=' + str(unit) + ')')
#	var unit: Node2D = Matrix.get_cell(position_to).unit
	var final_position: Vector2 = matrix_to_map(position_to)
#	var final_position = unit.get_position()
	var duration = _get_duration()
	Animator.animate(unit, "position", final_position, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)

func unit_exited(unit,  __  ,___ ,____):
	print('GUI.unit_exited(unit=' + str(unit) + ')')
	var final_position: Vector2 = unit.position + matrix_to_map(Vector2(1, 2)) - matrix_to_map(Vector2(1, 1))
	var duration = _get_duration()
	Animator.animate(unit, "position", final_position, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	Animator.animate(unit, "modulate", Color(1, 1, 1, 0), duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, true)

func unit_replaced(old_unit, new_unit, __ ,____):
	print('GUI.unit_replaced(from_unit=' + str(old_unit) + ' to_unit=' + str(new_unit) + ')')
	var coordinates: Vector2  = Matrix.get_unit_coordinates(old_unit)
	var duration = _get_duration()
	if not new_unit:
		Animator.animate(old_unit, "modulate", Color(1, 1, 1, 0), duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, true)


func unit_interacted(from, to_unit, action ,____):
	print('GUI.unit_interact(from' + str(from) + ' to_unit= ' + str(to_unit) + ')')
	if from is Unit:
		if action == "take_damage":
			_attack_unit_to_target(from, to_unit)
	
func cell_interacted(from, to_cell, action ,____):
	print('GUI.cell_interacte(from' + str(from) + ' to_cell= ' + str(to_cell) + ')')
	if from is Unit:
		if action == "take_damage":
			_attack_unit_to_target(from, to_cell)
	
func damage_taken(unit,  __  ,___ ,____):
	print('GUI.unit took damage(' + str(unit) + ')')
	
func _attack_unit_to_target(from_unit, to_target):
		print('GUI.unit_to_unit_attak(from' + str(from_unit) + ' to_target= ' + str(to_target) + ')')
#		var from_coordinates: Vector2  = Matrix.get_unit_coordinates(from_unit)
#		var matrix_from_coordinates: Vector2 = matrix_to_map(from_coordinates)
		var matrix_from_coordinates: Vector2  = from_unit.get_position()
		var matrix_to_coordinates: Vector2 = Vector2(-1, -1)
		if to_target is Unit:
			matrix_to_coordinates = to_target.get_position()
		else:
#			TODO import cell to this file 
			matrix_to_coordinates = matrix_to_map(to_target.get_coordinates())
			pass
#		else:
#			print('Unexpected to_target'  + str(to_target))
#			assert(false)
		var duration_first_step = _get_duration()
		var first_step = Animator.AnimationStep.new((matrix_to_coordinates * 2 + matrix_from_coordinates) / 3, duration_first_step)
		
		var duration_last_step = _get_duration()
		var last_step = Animator.AnimationStep.new(matrix_from_coordinates, duration_last_step)
		
		Animator.multi_animate(from_unit, "position", [first_step, last_step], Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		print( "unit_to_unit_attak finished")
	
# TODO: Remove later
func _on_Button_pressed():
	GameState._next_turn()
