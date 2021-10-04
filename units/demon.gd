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
	var moved = nimble_move()
	if moved:
		return
		
	var coordinates = Matrix.get_unit_coordinates(self)
	var neighbors = Matrix.get_neighbors(coordinates)
	var target = neighbors.bottom_right_neighbor
	if target:
		if target.get_race() != self._race:
			interact_to_unit(self, target, "take_damage")
			return
	target = neighbors.bottom_left_neighbor
	
	if target:
		if target.get_race() != self._race:
			interact_to_unit(self, target, "take_damage")
			return
	target = neighbors.bottom_neighbor
	
	if target:
		if target.get_race() != self._race:
			interact_to_unit(self, target, "take_damage")
			return

