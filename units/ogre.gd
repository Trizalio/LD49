extends Unit

func _ready():
	self._race =  "greenskin"
	self._tier =  3

func get_race():
	return "greenskin"
	
func get_tier():
	return 3
func act():
	var coordinates = Matrix.get_unit_coordinates(self)
	var neighbors = Matrix.get_neighbors(coordinates)
	if neighbors.left_neighbor:
		if neighbors.left_neighbor.get_race() != self._race:
#			emit_signal("interact", self, neighbors.left_neighbor, "take_damage")
			interact_to_unit(self, neighbors.left_neighbor, "take_damage")
			return

	move_straight()
