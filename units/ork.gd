extends Unit

func _ready():
	self._race =  "greenskin"
	self._tier =  2

func get_race():
	return "greenskin"
	
func get_tier():
	return 2
func act():
	var coordinates = Matrix.get_unit_coordinates(self)
	var neighbors = Matrix.get_neighbors(coordinates)
	var exist_neighbors = neighbors.get_exist_neighbors()
	if exist_neighbors.size():
		var neighbor = exist_neighbors[randi() % exist_neighbors.size()]
		interact_to_unit(self, neighbor, "take_damage")
		move_straight()
