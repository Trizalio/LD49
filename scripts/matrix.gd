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



# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var matix_length: int = 3
var matix_higths: int = 3
var matrix = []


# Called when the node enters the scene tree for the first time.
func _ready():
	_generate_cells()
	next_turn()
	get_cell(4,4)
#	print(matrix)
	pass # Replace with function body.




func _generate_cells():
	for x in matix_length:
		var matrix_line = []
		for y in matix_higths:
#			var cell = Cell.new()
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
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
