extends Node


class Cell:
#	var _var1
	var unit
	func _init():
		unit = null
		pass
#		self._var1 = 1
	
	func asgin_unit(new_unit):
		unit = new_unit
		pass


signal move_to_town(column_pos, line_pos)
signal appear_on_the_field(column_pos, line_pos)
signal move(column_pos_from, line_pos_from, column_pos_to, line_pos_to)


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var matrix_length: int = 3
var matrix_higths: int = 3
var matrix = []


# Called when the node enters the scene tree for the first time.
func _ready():
	_generate_cells()
	next_turn()
	pass # Replace with function body.




func _generate_cells():
	for line in matrix_higths:
		var matrix_line = []
		for column in matrix_length:
			matrix_line.append(Cell.new())
		matrix.append(matrix_line)
	

	
# will be replaced 
func _get_next_wave():
	return [1,2,3]


func next_turn():
	_do_on_next_tern_unit_actions()
	var next_wave_units = _get_next_wave()
	for unit in next_wave_units:
		pass
#		unit.do_action()
		

func _do_on_next_tern_unit_actions():
	for matrix_line_index in range(matrix.size() - 1, -1, -1):
		var matrix_line = matrix[matrix_line_index]
		for matrix_cell_index in range(matrix_line.size() - 1, -1, -1):
			var cell = matrix_line[matrix_cell_index]
			if cell.unit:
#				unit.do_action()
				print(matrix_line[matrix_cell_index])

func get_cell(x, y):
	 return matrix[x][y]
	

func move_to_town(column_pos, line_pos):
	matrix[line_pos ][column_pos].unit = null
	emit_signal("move_to_town", column_pos, line_pos)
#	matrix[line_pos ][column_pos] = null
	
func move_to(column_pos_from, line_pos_from, column_pos_to, line_pos_to):
	
	var cell = matrix[line_pos_from][column_pos_from]
	matrix[column_pos_to ][line_pos_to].unit = cell.unit
	cell.unit = null
	emit_signal("move", column_pos_from, line_pos_from, column_pos_to, line_pos_to)
	pass

func appear_on_the_field(column_pos: int, unit):
	if not matrix[matrix_higths - 1][column_pos].unit:
		matrix[matrix_higths - 1][column_pos].unit = unit
		emit_signal("appear_on_the_field", column_pos, matrix_higths - 1)
	
	
func get_neighbors(column_pos, line_pos):
	var neighbors=[]
	var top_neighbor = null
	if line_pos != 0:
		top_neighbor = matrix[line_pos - 1][column_pos]
	neighbors.append(top_neighbor)	
	
	var right_neighbor = null
	if column_pos != matrix_higths - 1:
		right_neighbor = matrix[line_pos][column_pos + 1]
	neighbors.append(right_neighbor)	
	
	var bot_neighbor = null
	if line_pos != matrix_length -1:
		bot_neighbor = matrix[line_pos + 1][column_pos]
		
	neighbors.append(bot_neighbor)	
	
	var left_neighbor = null
	if column_pos != 0:
		left_neighbor = matrix[line_pos][column_pos - 1]
	neighbors.append(left_neighbor)	
	return neighbors
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
