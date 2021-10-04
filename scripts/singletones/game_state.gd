extends Node

#onready var UnitClass = load("res://scenes/unit.gd")
var turn_number: int = 0
var god_mode: bool = false

var unit_race_to_amount_spawned: Dictionary = {}
var unit_race_to_amount_field: Dictionary = {}
var unit_race_to_amount_exit: Dictionary = {}

func _subsctibe():
	Matrix.connect("unit_exited", self, 'unit_exited_count')
	Matrix.connect("unit_entered", self, 'count_entered_unit')
	Matrix.connect("unit_replaced", self, 'on_unit_replaced')

func cast_spell(spell: Spell, destination: Vector2) -> void:
	spell.cast(destination)
	if not god_mode:
		_next_turn()

func unit_exited_count(unit):
	var race = unit.get_race()
	unit_race_to_amount_exit[race] = unit_race_to_amount_exit.get(race, 0) + 1
	_reduce_in_field_counter(race)
	print("unit_race_to_amount_field" + str(unit_race_to_amount_field))
	print("unit_race_to_amount_exit" + str(unit_race_to_amount_exit))
	
func on_unit_replaced(old_unit, new_unit):
	if not new_unit:
		var race = old_unit.get_race()
		_reduce_in_field_counter(race)

func _reduce_in_field_counter(race):
	assert (race in unit_race_to_amount_field)
	assert (unit_race_to_amount_field[race] != 0) 
	unit_race_to_amount_field[race] -= 1

func count_entered_unit(position):
	var unit = Matrix.get_cell(position).unit
	var race = unit.get_race()
	var tier = unit.get_tier()
	unit_race_to_amount_field[race] = unit_race_to_amount_field.get(race, 0) + 1
	unit_race_to_amount_spawned[race] = unit_race_to_amount_spawned.get(race, 0) + 1
	print("unit_race_to_amount_field " + str(unit_race_to_amount_field))
	print("unit_race_to_amount_spawned " + str(unit_race_to_amount_spawned))

func start_new_game():
	turn_number = 0
	Matrix._generate_cells()
	self._subsctibe()
	_next_turn()

func _next_turn():
	print('-----===== Units turn =====------')
#	Matrix.print_matrix()
	Matrix.call_on_all_units('act')
	_add_units_on_top_row()
	turn_number += 1
	print('-----===== Player turn =====------')
#	Matrix.print_matrix()
	
func _add_units_on_top_row():
#	if turn_number:
#		return
	for matrix_cell_index in range(Matrix.matrix.size() - 1, -1, -1):
		var position = Vector2(matrix_cell_index, 0)
		var cell = Matrix.get_cell(position)
		if cell.unit == null:
			var new_unit = UnitsGenerator.get_unit(matrix_cell_index)
			if new_unit != null:
#			var new_unit = get_new_unit(matrix_cell_index)
				Matrix.enter_matrix(position, new_unit)
	
#
#func get_new_unit(matrix_cell_index):
##	Fader.instance()
#	if matrix_cell_index >= 1:
#		return Imp.instance()
#	else:
#		return Zombie.instance()
#		UnitClass.Unit.new(2)
