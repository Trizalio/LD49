extends Unit

var hint = ('Unit: imp \nRace: daemons \nMove: move to one of 3 tiles'+
'ahead\n Properties: if no way - swaps with the first non-demon on 1 of the 3 front tiles')



func _ready():
	self._race =  "demon"
	self._tier =  1

func get_race():
	return "demon"

func get_tier():
	return 1
func _act():
	var coordinates = Matrix.get_unit_coordinates(self)
	var neighbors = Matrix.get_neighbors(coordinates)
	var target = neighbors.bottom_neighbor
	if target:
		if target.get_race() != self._race:
			target.change_status(self, "burning")
			return

	nimble_move()
	
