extends MarginContainer

onready var map: GridContainer = $parts/centered/map
onready var units = $parts/centered/map/units

# TODO: get from map
onready var separation: Vector2 = Vector2(4, 4)
var rand = RandomNumberGenerator.new()

func _ready():
	rand.randomize()
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

func unit_entered(position: Vector2):
	var column_pos = position.x
	var line_pos = position.y
	print('unit_appeared:', column_pos, " ", line_pos)
	var unit: Node2D = Matrix.get_cell(position).unit
	var unit_matrix_position = Vector2(column_pos, line_pos)
	units.add_child(unit)
	var final_position: Vector2 = matrix_to_map(unit_matrix_position)
	var delta = matrix_to_map(unit_matrix_position + Vector2(0, 1)) - final_position
	var start_position: Vector2 = final_position - delta
	unit.set_position(start_position)
	unit.set_modulate(Color(1, 1, 1, 0))
	var duration = rand.randf_range(0.5, 0.6)
	Animator.animate(unit, "position", final_position, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	Animator.animate(unit, "modulate", Color(1, 1, 1, 1), duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)

func unit_moved(unit, position_to: Vector2):
#	var unit: Node2D = Matrix.get_cell(position_to).unit
	print('unit moved: ', unit)
	var final_position: Vector2 = matrix_to_map(position_to)
	var duration = rand.randf_range(0.5, 0.6)
	Animator.animate(unit, "position", final_position, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)

func unit_exited(unit):
#	var unit: Node2D = Matrix.get_cell(position_to).unit
	print('unit moved: ', unit)
	
	var final_position: Vector2 = 2 * matrix_to_map(Vector2(1, 2)) - matrix_to_map(Vector2(1, 1))
	var duration = rand.randf_range(0.5, 0.6)
	Animator.animate(unit, "position", final_position, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	Animator.animate(unit, "modulate", Color(1, 1, 1, 0), duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, true)
	

func _on_Button_pressed():
	GameState._next_turn()
