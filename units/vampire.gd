extends Unit

#var _race = "undead"

var hint = ("Unit: vampire \nRace: undead \nMove: 'madly', in any direction"+
"to next three tiles, if no way - move to random way"+
"\nProperties: every 3 turns become weak; if weak - freeze random "+
"non-undead neighbour unit and returns to normal")

var is_week = false
var turn_counter = 0
var max_turn_counter = 3

func _ready():
	self._race =  "undead"
	self._tier =  3
#	change_status(self ,"lightning_shield")
func get_race():
	return "undead"

func get_tier():
	return 3

func _act():
#	if turn_counte == max_turn_counter:
#
#		var coordinates = Matrix.get_unit_coordinates(self)
#		var neighbors_pos = filter_positions([coordinates])
#		var not_undead_neighbors = []
#		for neighbor_pos in neighbors_pos:
#			var cell = Matrix.get_cell(neighbor_pos)
#			if cell.unit:
#				if cell.unit.get_race() != self._race:
#					not_undead_neighbors.append(cell.unit)
#
#		var neighbor_pos = Rand.rand_choice(neighbors_pos)
#		var target =  Rand.rand_choice(not_undead_neighbors)
#		if target:
#			target.change_status(self, "frozen")

		wander_move()
	
