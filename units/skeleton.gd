extends Unit

#var _race = "undead"

func _ready():
	self._race =  "undead"
	self._tier =  2
#	change_status(self ,"lightning_shield")
func get_race():
	return "undead"

func get_tier():
	return 2

func _act():
	print( "zooooooobie acting")
	var coordinates = Matrix.get_unit_coordinates(self)
	var neighbors = Matrix.get_neighbors(coordinates)
	if not neighbors.bottom_neighbor:
		move_straight()
	else:
		var exist_neighbors = neighbors.get_exist_neighbors()
#		if exist_neighbors.size():
#		var neighbor = exist_neighbors[randi() % exist_neighbors.size()]
#			interact_to_unit(self, neighbors.right_neighbor, "take_damage")
#			interact_to_unit(self, neighbors.right_neighbor, "take_damage")
#			if neighbors.right_neighbor.get_status() != "frozen":
#				neighbors.right_neighbor.change_status(self, "frozen")
#				emit_signal("interact", self, neighbors.left_neighbor, "change_status", "frozen")
#				return

	
