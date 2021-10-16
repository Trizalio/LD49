extends Node

const NeighborsClass = preload("res://utils/unit_neighbors.gd")


class Cell:
	var unit
	var _coordinates
	func _init(coordinates):
		unit = null
		_coordinates = coordinates
		print("Cell inited with coord:" + str(_coordinates))
	
	func asgin_unit(new_unit):
		unit = new_unit
		
	func release_unit():
		var unit_ = unit
		unit = null
		return unit_
		
	func get_coordinates():
		return _coordinates
#	func interact(from, action):
#		print("cell" + str(self) +  "interacted: from" + str(from) + " action: " + str(action))
#		if action == "smash":
#			var neighbors = Matrix.get_neighbors(_coordinates)
#			var _exist_neighbors = neighbors.get_exist_neighbors()
#			for neighbor in _exist_neighbors:
#				if neighbor != from:
#					neighbor.take_damage(from)
#			print(str(_exist_neighbors))
		pass
	
	func _to_string():
		return 'Cell(id=' + str(get_instance_id()) + ', unit=' + str(unit) + ')' 

signal unit_exited(unit)
signal unit_entered(position)
signal unit_moved(position_from, position_to, unit)
signal unit_interacted(from, to_unit, action)
#signal unit_to_unit_status_change(from, to_unit, status)
signal unit_status_changed(unit, action, inst, from)
signal unit_replaced(old_unit, new_unit)
signal damage_taken(unit)
signal cell_interacted(from, to_cell, action)

signal animate2(unit, method, arg)

var matrix_width: int = 5
var matrix_height: int = 5
var matrix = []

func _generate_cells():
	for y in matrix_height:
		var matrix_line = []
		for x in matrix_width:
			matrix_line.append(Cell.new(Vector2(x, y)))
		matrix.append(matrix_line)
#func is_in_matix(position: Vector2):
#	if position.x > matrix_width -1 or  position.x < 0 :
#		return false
#	if position.y > matrix_height - 1 or  position.y < 0:
#		return false
#	return true
	
func call_on_all_units(method: String):
#	for y in range(matrix_height - 1, -1, -1):
#		for x in range(matrix_width - 1, -1, -1):
	for y in range(matrix_height):
		for x in range(matrix_width):
			var cell: Cell = get_cell(Vector2(x, y))
			if cell.unit:
				cell.unit.call(method)

func get_cell(position: Vector2) -> Cell:
	 return matrix[position.y][position.x]

func get_unit(position: Vector2) -> Cell:
	 return get_cell(position).unit
#
#func exit_from(position: Vector2):
#	var cell = get_cell(position)
#	print('Matrix.exit_from(from=' + str(position) + ')')
#	var unit = cell.release_unit()
#	emit_signal("unit_exited", unit)
	
func is_next_to_town(position: Vector2):
	return position.y == (matrix_height - 1)
#
#func move_unit(position_from: Vector2, position_to: Vector2) -> void:
#	var cell_from = get_cell(position_from)
#	var cell_to = get_cell(position_to)
#	print('Matrix.move(from=' + str(position_from) + ', to=' + str(position_to) + ')')
#	var unit = cell_from.unit
#	cell_from.unit = null
#	cell_to.unit = unit
#	emit_signal("unit_moved", position_from, position_to, unit)

func enter_matrix(position: Vector2, unit, delay: bool = true, force: bool = false) -> void:
#	assert(position.y == 0)
	assert(unit != null)
	var cell = get_cell(position)
#	print('Matrix.enter_matrix(cell=' + str(cell) + ', unit=' + str(unit) + ')')
	if force and cell.unit != null:
		cell.unit.die()
		
	if cell.unit != null:
		return
	cell.unit = unit
	unit.on_enter_matrix(delay)
#	emit_signal("animate2", unit, 'enter_matrix', null)
#	unit.connect("animate", self, 'reemit_animate')
#	unit.connect("interact", self, 'interact_with_unit')
#	unit.connect("status_changed", self, 'raise_unit_status_changed')
#	unit.connect("replace_unit", self, 'replace_unit')
#	unit.connect("damage_taken", self, 'damage_taken')
#	unit.connect("interact_with_cell", self, 'interact_with_cell_')
#	emit_signal("unit_entered", position)
#
#func reemit_animate(target, method, arg):
#	print('reemit')
#	emit_signal("animate2", target, method, arg)

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

#
#func replace_unit(old_unit, new_unit):
#	var position = get_unit_coordinates(old_unit)
#	assert (position.x != -1 and position.y != -1)
#	matrix[position.y][position.x].unit = new_unit
#	emit_signal("unit_replaced", old_unit, new_unit)
#
#func raise_unit_status_changed(unit,  action, inst, from):
#	print("rerais status change" + str(unit))
#	emit_signal("unit_status_changed", unit,  action, inst, from)
#
#func raise_unit_to_unit_status_change(from_unit, to_unit, status):
#	interact_with_unit(from_unit, to_unit, "change_status", status)
##	emit_signal("unit_to_unit_status_change", unit, status)
#
#func damage_taken(unit):
#	emit_signal("damage_taken", unit)
#
#func interact_with_unit(from, to_unit, action: String, arg_1 = null, arg_2 = null):
#	emit_signal("unit_interacted", from, to_unit, action)
#	if action == "take_damage":
#		to_unit.call(action, from)
#	else:
#		to_unit.call(action)	
#
#func interact_with_cell_(from, to_cell: Cell, action: String):
#	print('cell_interacted:' + str(to_cell))
##	if sig
#	var unit = to_cell.unit
##	to_cell.interact(from, action)
#	if unit: 
#		if action == "take_damage":
#			unit.call(action, from)
#
#	emit_signal("cell_interacted", from, to_cell, action)
##
