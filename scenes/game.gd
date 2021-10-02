extends MarginContainer

onready var map: GridContainer = $parts/centered/map
onready var units = $parts/centered/map/units

# TODO: get from map
onready var separation: Vector2 = Vector2(4, 4)
var rand = RandomNumberGenerator.new()

func _ready():
	rand.randomize()
	Matrix.connect("appear_on_the_field", self, 'unit_appeared')
	
	GameState.start_new_game()
	
func matrix_to_map(matrix_position: Vector2) -> Vector2:
	var node_name = str(matrix_position.x) + str(matrix_position.y)
	var tile: TextureRect = map.get_node(node_name)
	var position = tile.get_position()
	var cell_size = tile.get_rect().size
	return position + cell_size / 2

func unit_appeared(column_pos, line_pos):
	print('unit_appeared:', column_pos, " ", line_pos)
	var unit: Node2D = Matrix.get_cell(column_pos, line_pos).unit
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
#	unit.set_position(get_node_position_from_map_position(Vector2(column_pos, line_pos)))
#	unit.set_position(Vector2(
#		(column_pos + 0.5) * cell_size.x + column_pos * separation.x, 
#		(line_pos + 0.5) * cell_size.y + line_pos * separation.y
#	))
#	var unit_start_position = Vector2(
#		(column_pos + 0.5) * cell_size.x + column_pos * separation.x, 
#		(line_pos + 0.5) * cell_size.y + line_pos - 1) * separation.y
#	)
#	var position = map.get_node(node_name).global_position
#	print(position, " || ", cell_size)
#	map.add_child_below_node(node_name)
	


func _on_Button_pressed():
	GameState._next_turn()
