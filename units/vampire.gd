extends Unit

#var _race = "undead"

var hint = ("Unit: vampire \nRace: undead \nMove: 'madly', in any direction"+
"to next three tiles, if no way - move to random way"+
"\nProperties: every 3 turns become weak; if weak - freeze random "+
"non-undead neighbour unit and returns to normal")


func _ready():
	self._race =  "undead"
	self._tier =  3
	change_status(self ,"lightning_shield")
func get_race():
	return "undead"

func get_tier():
	return 3

func _act():
	var coordinates = Matrix.get_unit_coordinates(self)
	var neighbors = Matrix.get_neighbors(coordinates)
	if neighbors.right_neighbor:
		if neighbors.right_neighbor.get_race() != self._race:
			if neighbors.right_neighbor.get_status() != "frozen":
				neighbors.right_neighbor.change_status(self, "frozen")

	wander_move()
	
