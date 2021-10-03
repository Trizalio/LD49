extends Node

#onready var UnitClass = load("res://scenes/unit.gd")
onready var Imp = load("res://units/imp.tscn")
onready var Zombie = load("res://units/zombie.tscn")
var turn_number = 0
var unit_race_to_amount_exit = {
	}

var unit_race_to_amount_field = {
	}

var unit_race_to_amount_spawned = {
	}

#func _ready():
#	Matrix.connect("unit_moved", self, 'unit_exited_count')
#	print(" game state ready ")

func _subsctibe():
	Matrix.connect("unit_exited", self, 'unit_exited_count')
	Matrix.connect("unit_entered", self, 'unit_enterd_count')
	Matrix.connect("unit_replaced", self, 'unit_killed')


func unit_exited_count(unit):
	var race = unit.get_race()
	if !(race in unit_race_to_amount_exit):
		unit_race_to_amount_exit[race] = 0
		

	unit_race_to_amount_exit[race] += 1
	_reduce_in_field_counter(race)
	print("unit_race_to_amount_field" + str(unit_race_to_amount_field))
	print("unit_race_to_amount_exit" + str(unit_race_to_amount_exit))
	
func unit_killed(old_unit, new_unit):
	if not new_unit:
		var race = old_unit.get_race()
		_reduce_in_field_counter(race)
		
	pass
func _reduce_in_field_counter(race):
	assert (race in unit_race_to_amount_field)
	assert (unit_race_to_amount_field[race] != 0) 
	unit_race_to_amount_field[race] -= 1
	

func unit_enterd_count(position):
	var unit = Matrix.get_cell(position).unit
	var race = unit.get_race()
	var tier = unit.get_tier()
	if !(race in unit_race_to_amount_field):
		unit_race_to_amount_field[race] = 0
		
	if !(race in unit_race_to_amount_spawned):
		unit_race_to_amount_spawned[race] = 0
		
	unit_race_to_amount_field[race] += 1
	unit_race_to_amount_spawned[race] += 1
	print("unit_race_to_amount_field " + str(unit_race_to_amount_field))
	print("unit_race_to_amount_spawned " + str(unit_race_to_amount_spawned))

func start_new_game():
	turn_number = 0
	Matrix._generate_cells()
	self._subsctibe()
	pass # Replace with function body.
#
#func cast_spell(target: Vector2, spell: Spell):
#
#	pass

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
			var new_unit = get_new_unit(matrix_cell_index)
			Matrix.enter_matrix(position, new_unit)
		else:
#			print('-- cell[', position, '].unit is NOT null')
			pass
#	print(Matrix.matrix)
	

func get_new_unit(matrix_cell_index):
#	Fader.instance()
	if matrix_cell_index >= 1:
		return Imp.instance()
	else:
		return Zombie.instance()
#		UnitClass.Unit.new(2)
