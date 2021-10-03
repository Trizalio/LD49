extends MarginContainer

onready var map: GridContainer = $parts/centered/map
onready var units = $parts/centered/map/units

# TODO: get from map
onready var separation: Vector2 = Vector2(4, 4)

func _ready():
	Matrix.connect("unit_entered", self, 'unit_entered')
	Matrix.connect("unit_exited", self, 'unit_exited')
	Matrix.connect("unit_moved", self, 'unit_moved')
	
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
	
# TODO: Remove later
func _on_Button_pressed():
	GameState._next_turn()
