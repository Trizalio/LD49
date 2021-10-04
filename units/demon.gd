extends Unit

var hint = ('Unit: daemon \nRace: daemons \nMove: move to one of 3 tiles'+
'ahead\n Properties: if not way - attack not the demon on 1 of the 3 front tiles')



func _ready():
	self._race =  "demon"
	self._tier =  2

func get_race():
	return "demon"

func get_tier():
	return 1
func _act():
	var coordinates = Matrix.get_unit_coordinates(self)
	var neighbors = Matrix.get_neighbors(coordinates)
	if neighbors.left_neighbor:
		if neighbors.left_neighbor.get_race() != self._race:
#			emit_signal("interact", self, neighbors.left_neighbor, "take_damage")
#			interact_to_unit(self, neighbors.left_neighbor, "take_damage")
			return

	move_straight()

