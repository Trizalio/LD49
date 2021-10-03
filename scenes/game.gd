extends MarginContainer

onready var map: GridContainer = $parts/centered/map
onready var units = $parts/centered/map/units

# TODO: get from map
onready var separation: Vector2 = Vector2(4, 4)

func _ready():
	Matrix.connect("unit_entered", self, 'unit_entered')
	Matrix.connect("unit_exited", self, 'unit_exited')
	Matrix.connect("unit_moved", self, 'unit_moved')
	Matrix.connect("unit_replaced", self, 'unit_replaced')
	Matrix.connect("unit_interacted", self, 'unit_interacted')
	
	GameState.start_new_game()
	
func matrix_to_map(matrix_position: Vector2) -> Vector2:
	var node_name = str(matrix_position.x) + str(matrix_position.y)
	var tile: TextureRect = map.get_node(node_name)
	var position = tile.get_position()
	var cell_size = tile.get_rect().size
	return position + cell_size / 2

func unit_entered(unit_matrix_position: Vector2):
	print('GUI.unit_appeared(position=' + str(unit_matrix_position) + ')')
	var unit: Node2D = Matrix.get_cell(unit_matrix_position).unit
	units.add_child(unit)
	var final_position: Vector2 = matrix_to_map(unit_matrix_position)
	var delta = matrix_to_map(unit_matrix_position + Vector2(0, 1)) - final_position
	var start_position: Vector2 = final_position - delta
	unit.set_position(start_position)
	unit.set_modulate(Color(1, 1, 1, 0))
	var duration = Rand.randf_range(0.5, 0.6)
	Animator.animate(unit, "position", final_position, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	Animator.animate(unit, "modulate", Color(1, 1, 1, 1), duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)

func unit_moved(__, position_to: Vector2):
	print('GUI.unit_moved(position_to=' + str(position_to) + ')')
	var unit: Node2D = Matrix.get_cell(position_to).unit
	var final_position: Vector2 = matrix_to_map(position_to)
	var duration = Rand.randf_range(0.5, 0.6)
	Animator.animate(unit, "position", final_position, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)

func unit_exited(unit):
	print('GUI.unit_exited(unit=' + str(unit) + ')')
	var final_position: Vector2 = 2 * matrix_to_map(Vector2(1, 2)) - matrix_to_map(Vector2(1, 1))
	var duration = Rand.randf_range(0.5, 0.6)
	Animator.animate(unit, "position", final_position, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	Animator.animate(unit, "modulate", Color(1, 1, 1, 0), duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, true)

func unit_replaced(old_unit, new_unit):
	print('GUI.unit_replaced(from_unit=' + str(old_unit) + ' to_unit=' + str(new_unit) + ')')
	var coordinates: Vector2  = Matrix.get_unit_coordinates(old_unit)
	var duration = Rand.randf_range(0.5, 0.6)
	if not new_unit:
		Animator.animate(old_unit, "modulate", Color(1, 1, 1, 0), duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, true)
		pass
	pass
func unit_interacted(from, to_unit, action):
	print('GUI.unit_interact(from' + str(from) + ' to_unit= ' + str(to_unit) + ')')
	if from:
		if action == "take_damage":
			_attack_unit_to_unit(from, to_unit)
	
	pass
	
func _attack_unit_to_unit(from_unit, to_unit):
		print('GUI.unit_to_unit_attak(from' + str(from_unit) + ' to_unit= ' + str(to_unit) + ')')
		var from_coordinates: Vector2  = Matrix.get_unit_coordinates(from_unit)
		var matrix_from_coordinates: Vector2 = matrix_to_map(from_coordinates)
		
		var to_coordinates: Vector2  = Matrix.get_unit_coordinates(to_unit)
		var matrix_to_coordinates: Vector2 = matrix_to_map(to_coordinates)
		
		
		var duration_first_step = Rand.randf_range(0.5, 0.6) 
		var first_step = Animator.AnimationStep.new((matrix_to_coordinates * 2 + matrix_from_coordinates) / 3, duration_first_step)
		
		var duration_last_step = Rand.randf_range(0.7, 0.8)
		var last_step = Animator.AnimationStep.new(matrix_from_coordinates, duration_last_step)
		
		var duration_fist_step = Rand.randf_range(0.5, 0.6)
		Animator.multi_animate(from_unit, "position", [first_step, last_step], Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
#		Animator.animate(from_unit, "position", from_coordinates, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		print( "unit_to_unit_attak finished")
		pass
	
# TODO: Remove later
func _on_Button_pressed():
	GameState._next_turn()
