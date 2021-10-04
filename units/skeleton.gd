extends Unit

#var _race = "undead"

var hint = ("Unit: skeleton \nRace: undead \nMove: 'madly', in any direction"+
"to next three tiles, if no way - move to random way"+
"\nProperties: if no way - attack random non-undead unit")



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
	var mooved = wander_move()
	if !mooved:
		var traget = neighbors.bottom_neighbor
		if traget:
			if traget.get_race() != self._race:
				interact_to_unit(self, traget, "take_damage")
				return

	
