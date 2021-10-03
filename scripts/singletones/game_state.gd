extends Node

#onready var UnitClass = load("res://scenes/unit.gd")
onready var Imp = load("res://units/imp.tscn")
var turn_number = 0

func start_new_game():
	turn_number = 0
	Matrix._generate_cells()
	pass # Replace with function body.
	

func _next_turn():
	print('-----===== Units turn =====------')
#	Matrix.print_matrix()
	Matrix.call_on_all_units('act')
	_add_units_on_top_row()
	turn_number += 1
	print('-----===== Player turn =====------')
	Matrix.print_matrix()
	

func _add_units_on_top_row():
	if turn_number:
		return
#	print('_add_units_on_top_row:, cells: ', Matrix.matrix.size())
	for matrix_cell_index in range(Matrix.matrix.size() - 1, -1, -1):
		var position = Vector2(matrix_cell_index, 0)
		var cell = Matrix.get_cell(position)
		if cell.unit == null:
#			print('-- cell[', position, '].unit is null')
			var new_unit = get_new_unit()
			Matrix.enter_matrix(position, new_unit)
		else:
#			print('-- cell[', position, '].unit is NOT null')
			pass
#	print(Matrix.matrix)
	

func get_new_unit():
#	Fader.instance()
	return Imp.instance()
#		UnitClass.Unit.new(2)
