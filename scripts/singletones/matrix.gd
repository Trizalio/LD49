extends Node

const NeighborsClass = preload("res://utils/unit_neighbors.gd")


class Cell:
	var unit
	func _init():
		unit = null
	
	func asgin_unit(new_unit):
		unit = new_unit
		
	func release_unit():
		var unit_ = unit
		unit = null
		return unit_


signal unit_exited(position)
signal unit_entered(position)
signal unit_moved(unit, position_to)


var matrix_length: int = 3
var matrix_hight: int = 3
var matrix = []


func _generate_cells():
	for line in matrix_hight:
		var matrix_line = []
		for column in matrix_length:
			matrix_line.append(Cell.new())
		matrix.append(matrix_line)

func _do_on_next_tern_unit_actions():
	for matrix_line_index in range(matrix.size() - 1, -1, -1):
		var matrix_line = matrix[matrix_line_index]
		for matrix_cell_index in range(matrix_line.size() - 1, -1, -1):
			var cell = matrix_line[matrix_cell_index]
			if cell.unit:
				print('act', matrix_cell_index, matrix_line_index)
				cell.unit.act()

func get_cell(position: Vector2):
	 return matrix[position.y][position.x]
	
func move_to_town(position: Vector2):
	var cell = get_cell(position)
	var unit = cell.release_unit()
	emit_signal("unit_exited", unit)
	
func is_next_to_town(position: Vector2):
	print('is_next_to_town: ', position, ': ', position.y == (matrix_hight - 1))
	return position.y == (matrix_hight - 1)
	
func move_to(position_from: Vector2, position_to: Vector2):
	print('move from ', position_from, ' to ', position_to)
	var cell_from = get_cell(position_from)
	var cell_to = get_cell(position_to)
	var unit = cell_from.unit
	print('cell_from:', cell_from)
	cell_from.unit = null
	print('cell_from:', cell_from.unit)
	cell_to.unit = unit
	emit_signal("unit_moved", unit, position_to)

func enter_matrix(position: Vector2, unit):
	print('Matrix.enter_matrix')
	assert(position.y == 0)
	var cell = get_cell(position)
	assert(cell.unit == null)
#	if cell.unit == null:
	cell.unit = unit
	emit_signal("unit_entered", position)

func get_unit_coordinates(unit) -> Vector2:
	for line in matrix_hight:
		for column in matrix_length:
			if matrix[line][column].unit == unit:
				return	Vector2(column, line)
	return Vector2(-1, -1)
	
func print_matrix():
	for matrix_line_index in range(0, matrix.size()):
		var matrix_line = matrix[matrix_line_index]
		var line = ''
		for matrix_cell_index in range(0, matrix_line.size()):
			var cell = matrix_line[matrix_cell_index]
			line += str(cell)
			line += '>'
			line += str(cell.unit)
			line += '___'
			
		print(line)

func get_neighbors(position: Vector2):
	var column_pos = position.x
	var line_pos = position.y
	var top_neighbor = null
	if line_pos != 0:
		top_neighbor = matrix[line_pos - 1][column_pos].unit
	
	var top_right_neighbor = null
	if line_pos != 0 and column_pos != matrix_hight - 1:
		top_right_neighbor = matrix[line_pos - 1][column_pos + 1].unit
		
		
	var right_neighbor = null
	if column_pos != matrix_hight - 1:
		right_neighbor = matrix[line_pos][column_pos + 1].unit
	
	var bottom_right_neighbor = null
	if  column_pos != matrix_hight - 1 and  line_pos != matrix_length -1:
		bottom_right_neighbor = matrix[line_pos + 1][column_pos + 1].unit
		
	var bottom_neighbor = null
	if line_pos != matrix_length -1:
		bottom_neighbor = matrix[line_pos + 1][column_pos].unit
		
	
	var bottom_left_neighbor = null
	if column_pos != 0 and  line_pos != matrix_length -1:
		bottom_left_neighbor =  matrix[line_pos + 1][column_pos - 1].unit
	
	var left_neighbor = null
	if column_pos != 0:
		left_neighbor = matrix[line_pos][column_pos - 1].unit
		
	
	var top_left_neighbor = null
	if column_pos != 0 and line_pos != 0:
		top_left_neighbor = matrix[line_pos -1][column_pos - 1].unit
		
	return NeighborsClass.UnitNeighbors.new(
		top_neighbor,
		top_right_neighbor,
		right_neighbor,
		bottom_right_neighbor,
		bottom_neighbor,
		bottom_left_neighbor,
		left_neighbor,
		top_left_neighbor
	)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
