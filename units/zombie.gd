extends Unit

#var _race = "undead"

func _ready():
	self._race =  "undead"
	self._tier =  1

func get_race():
	return "undead"
	
func get_tier():
	return 1

func act():
	print( "zooooooobie acting")
	var coordinates = Matrix.get_unit_coordinates(self)
	var neighbors = Matrix.get_neighbors(coordinates)
	if neighbors.right_neighbor:
		if neighbors.right_neighbor.get_race() != self._race:
#			interact_to_unit(self, neighbors.right_neighbor, "take_damage")
#			interact_to_unit(self, neighbors.right_neighbor, "take_damage")
			neighbors.right_neighbor.change_status("frozen")
			return

	move_straight()
	
