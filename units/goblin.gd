extends Unit

func _ready():
	self._race =  "greenskin"
	self._tier =  1

func get_race():
	return "greenskin"
	
func get_tier():
	return 1
func _act():
	var coordinates = Matrix.get_unit_coordinates(self)
	var neighbors = Matrix.get_neighbors(coordinates)
	if !neighbors.bottom_neighbor:
		move_straight()
		var neighbors_second_step = Matrix.get_neighbors(Matrix.get_unit_coordinates(self))
		if !neighbors_second_step.bottom_neighbor:
			move_straight()
	else :
		interact_to_unit(self, neighbors.bottom_neighbor, "take_damage")
		return

