extends Unit


func _ready():
	self._race =  "demon"


func act():
	var coordinates = Matrix.get_unit_coordinates(self)
	var neighbors = Matrix.get_neighbors(coordinates)
	if neighbors.left_neighbor:
		if neighbors.left_neighbor.get_race() != self._race:
			interact_to_unit(self, neighbors.left_neighbor, "take_damage")
	move_straight()
