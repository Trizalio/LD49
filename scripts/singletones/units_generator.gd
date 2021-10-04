extends Node

onready var Imp = preload("res://units/imp.tscn")
onready var Zombie = preload("res://units/zombie.tscn")
onready var UndeadSkeleton = preload("res://units/skeleton.tscn")
onready var Vampire = preload("res://units/vampire.tscn")
onready var Goblin = preload("res://units/goblin.tscn")
onready var Ogre = preload("res://units/ogre.tscn")
onready var Ork = preload("res://units/ork.tscn")

var faction_to_units = {}
func _ready():
	faction_to_units = {
#		'undead': [Zombie, UndeadSkeleton, Vampire], 
		'undead': [Zombie, Zombie, Zombie], 
		'orc': [Ogre, Ogre, Ogre],
#		'orc': [Goblin, Goblin, Goblin],
#		'demon': [Imp, Imp, Imp]
	}


func get_unit(column_index):
	var matrix_capacity = Matrix.matrix_width * Matrix.matrix_height
	var units_on_field = 0
	for race in GameState.unit_race_to_amount_spawned:
		units_on_field += GameState.unit_race_to_amount_spawned[race]
	
	var units_in_column = 0
	for y in range(Matrix.matrix_height):
		if Matrix.get_cell(Vector2(column_index, y)).unit != null:
			units_in_column += 1
	var column_fill_factor = float(units_in_column) / Matrix.matrix_height
	
	var fill_factor = float(units_on_field) / float(matrix_capacity)
	var spawn_chance = (0.4 + (1 - fill_factor * 1.0)  * 0.3) * (1 - column_fill_factor * 0.5)
	if not Rand.check(spawn_chance):
#		print('skip spawn')
		return 
	
	var faction = Rand.rand_choice(faction_to_units.keys())
	var faction_types = faction_to_units[faction]
	var upgrade_chance = 0.5
	var type_index = 0
	while type_index < len(faction_types) - 1 and Rand.check(upgrade_chance):
		type_index += 1
	var selected_type = faction_types[type_index]
	print('faction selected:', faction, ', index:', type_index)
	
	return selected_type.instance()
