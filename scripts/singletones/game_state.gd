extends Node

#onready var UnitClass = load("res://scenes/unit.gd")
onready var Imp = load("res://units/imp.gd")


func start_new_game():
	Matrix._generate_cells()
	pass # Replace with function body.
	

func _next_turn():
	Matrix._do_on_next_tern_unit_actions()
	_add_units_on_top_row()

func _add_units_on_top_row():
	print('_add_units_on_top_row:, cells: ', Matrix.matrix.size())
	for matrix_cell_index in range(Matrix.matrix.size() - 1, -1, -1):
		var cell = Matrix.get_cell(matrix_cell_index, 0)
		if cell.unit == null:
			print('-- cell[', matrix_cell_index, '].unit is null')
			var new_unit = get_new_unit()
			Matrix.appear_on_the_field(matrix_cell_index, new_unit)
		else:
			print('-- cell[', matrix_cell_index, '].unit is NOT null')
	print(Matrix.matrix)

func get_new_unit():
	return Imp.new()
#		UnitClass.Unit.new(2)
