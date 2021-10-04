extends Unit

func _ready():
	self._race =  "greenskin"
	self._tier =  3

func get_race():
	return "greenskin"
	
func get_tier():
	return 3

var _ready_to_attak = 	false

func _act():
	var coordinates = Matrix.get_unit_coordinates(self)
	var neighbors = Matrix.get_neighbors(coordinates)
	
	if neighbors.bottom_neighbor:
		if _ready_to_attak:
#			emit_signal("interact", self, neighbors.left_neighbor, "take_damage")
			interact_to_unit(self, neighbors.bottom_neighbor, "take_damage")
			_ready_to_attak = false
		else:
			_ready_to_attak = true
				
		return
	move_straight()
