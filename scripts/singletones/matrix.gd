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
	
	func _to_string():
		return 'Cell(id=' + str(get_instance_id()) + ', unit=' + str(unit) + ')' 

signal unit_exited(position)
signal unit_entered(position)
signal unit_moved(position_from, position_to)
signal unit_interacted(from, to_unit, action)
signal unit_status_changed(unit, status)
signal unit_replaced(old_unit, new_unit)
signal damage_taken(unit)


var matrix_width: int = 3
var matrix_height: int = 3
var matrix = []




func _generate_cells():
	for y in matrix_height:
		var matrix_line = []
		for x in matrix_width:
			matrix_line.append(Cell.new())
		matrix.append(matrix_line)
		
func call_on_all_units(method: String):
	for y in range(matrix_height - 1, -1, -1):
		for x in range(matrix_width - 1, -1, -1):
			var cell: Cell = get_cell(Vector2(x, y))
			if cell.unit:
				cell.unit.call(method)

func get_cell(position: Vector2) -> Cell:
	 return matrix[position.y][position.x]
	
func exit_from(position: Vector2):
	var cell = get_cell(position)
	print('Matrix.exit_from(from=' + str(position) + ')')
	var unit = cell.release_unit()
	emit_signal("unit_exited", unit)
	
func is_next_to_town(position: Vector2):
	return position.y == (matrix_height - 1)
	
func move_unit(position_from: Vector2, position_to: Vector2) -> void:
	var cell_from = get_cell(position_from)
	var cell_to = get_cell(position_to)
	print('Matrix.move(from=' + str(position_from) + ', to=' + str(position_to) + ')')
	var unit = cell_from.unit
	cell_from.unit = null
	cell_to.unit = unit
	emit_signal("unit_moved", position_from, position_to)

func enter_matrix(position: Vector2, unit: Unit) -> void:
	assert(position.y == 0)
	assert(unit != null)
	var cell = get_cell(position)
	print('Matrix.enter_matrix(cell=' + str(cell) + ', unit=' + str(unit) + ')')
	assert(cell.unit == null)
	cell.unit = unit
	unit.connect("interact", self, 'interact_with_unit')
	unit.connect("status_changed", self, 'unit_status_changed')
	unit.connect("replace_unit", self, 'replace_unit')
	unit.connect("damage_taken", self, 'damage_taken')
	emit_signal("unit_entered", position)

func get_unit_coordinates(unit) -> Vector2:
	for line in matrix_height:
		for column in matrix_width:
			if matrix[line][column].unit == unit:
				return	Vector2(column, line)
	return Vector2(-1, -1)
	
func print_matrix():
	print('Matrix state:')
	for matrix_line_index in range(0, matrix.size()):
		var matrix_line = matrix[matrix_line_index]
		var line = '   '
		for matrix_cell_index in range(0, matrix_line.size()):
			var cell = matrix_line[matrix_cell_index]
			line += str(cell)
			line += '\t'
			
		print(line)


func replace_unit(old_unit: Unit, new_unit: Unit):
	var position = get_unit_coordinates(old_unit)
	assert (position.x != -1 and position.y != -1)
	matrix[position.y][position.x].unit = new_unit
	emit_signal("unit_replaced", old_unit, new_unit)
	
func raise_unit_status_changed(unit: Unit, status):
	emit_signal("unit_status_changed", unit, status)
		
func damage_taken(unit: Unit):
	emit_signal("damage_taken", unit)
	
func interact_with_unit(from, to_unit: Unit, action: String):
	emit_signal("unit_interacted", from, to_unit, action)
	to_unit.call(action)

func get_neighbors(position: Vector2):
	var column_pos = position.x
	var line_pos = position.y
	var top_neighbor = null
	if line_pos != 0:
		top_neighbor = matrix[line_pos - 1][column_pos].unit
	
	var top_right_neighbor = null
	if line_pos != 0 and column_pos != matrix_height - 1:
		top_right_neighbor = matrix[line_pos - 1][column_pos + 1].unit
		
		
	var right_neighbor = null
	if column_pos != matrix_height - 1:
		right_neighbor = matrix[line_pos][column_pos + 1].unit
	
	var bottom_right_neighbor = null
	if  column_pos != matrix_height - 1 and  line_pos != matrix_width -1:
		bottom_right_neighbor = matrix[line_pos + 1][column_pos + 1].unit
		
	var bottom_neighbor = null
	if line_pos != matrix_width -1:
		bottom_neighbor = matrix[line_pos + 1][column_pos].unit
		
	
	var bottom_left_neighbor = null
	if column_pos != 0 and  line_pos != matrix_width -1:
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
