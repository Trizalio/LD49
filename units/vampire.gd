extends Unit

#var _race = "undead"

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

	move_straight()
	
