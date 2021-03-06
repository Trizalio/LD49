extends Node

signal active_spells_changed(spell_names)
#onready var UnitClass = load("res://scenes/unit.gd")
var turn_number: int
const god_mode: bool = false
const castle_capacity = 10

const base_time_step = 0.4
const duration_deviation_fraction = 0.2
var game = null

func get_rand_animation_duration() -> float:
	var min_time_step = base_time_step * (1 - duration_deviation_fraction)
	var max_time_step = base_time_step * (1 + duration_deviation_fraction)
	return Rand.float_in_range(min_time_step, max_time_step)

const element_to_spell_names = {
	"fire": ['fireball', 'firejet'],
	"lightning": ['lightning_shield', 'chain_lightning'],
	"frost": ['frost_circle', 'frost_shard'],
}
var current_element: String

#var unit_race_to_amount_spawned: Dictionary = {}
#var unit_race_to_amount_field: Dictionary = {}
var unit_race_to_amount_exit: Dictionary

func _subsctibe():
	pass

func cast_spell(spell: Spell, destination: Vector2) -> void:
	spell._cast(destination)
	if not god_mode:
		_next_turn()
		
func roll_spells():
	var possible_elements = []
	for element in element_to_spell_names:
		if element != current_element:
			possible_elements.append(element)
	current_element = Rand.choice(possible_elements)
	emit_signal('active_spells_changed', element_to_spell_names[current_element])

func _end_game():
	if unit_race_to_amount_exit.get(UnitUtils.Race.Undead, 0) > castle_capacity / 2:
		SceneChanger.goto_scene('res://scenes/ends/end_undeads.tscn')
	elif unit_race_to_amount_exit.get(UnitUtils.Race.Demon, 0) > castle_capacity / 2:
		SceneChanger.goto_scene('res://scenes/ends/end_demons.tscn')
	elif unit_race_to_amount_exit.get(UnitUtils.Race.Greenskin, 0) > castle_capacity / 2:
		SceneChanger.goto_scene('res://scenes/ends/end_orks.tscn')
	else:
		SceneChanger.goto_scene('res://scenes/ends/end_fail.tscn')

func unit_exited(unit):
	var race = unit.get_race()
	unit_race_to_amount_exit[race] = unit_race_to_amount_exit.get(race, 0) + 1
#	_reduce_in_field_counter(race)
	var total_exited_units = 0
	
	for current_race in unit_race_to_amount_exit.keys():
		total_exited_units += unit_race_to_amount_exit[current_race]
		
	print(total_exited_units, ' / ',  castle_capacity)
	if total_exited_units == castle_capacity:
		_end_game()
		
#	print("unit_race_to_amount_field" + str(unit_race_to_amount_field))
	print("unit_race_to_amount_exit" + str(unit_race_to_amount_exit))
	
func start_new_game(game_scene):
	game = game_scene
	current_element = ''
	unit_race_to_amount_exit = {}
	turn_number = 0
	Matrix._generate_cells()
	self._subsctibe()
	if not god_mode:
		_next_turn()

func _next_turn():
	turn_number += 1
	roll_spells()
	print('-----===== Units turn =====------')
#	Matrix.print_matrix()
	Matrix.call_on_all_units('act')
	if not god_mode:
		_add_units_on_top_row()
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
