extends Unit

var hint = ("Unit: ogre \nRace: greenskins \nMove: only straight walk, "+
"Properties: agressive, attack each other; swings a club for 1 turn," +
"attack goal in front of himself, stun his neighbours")


func _ready():
	self._race =  "greenskin"
	self._tier =  3

func get_race():
	return "greenskin"
	
func get_tier():
	return 3

var _ready_to_attak = 	false
var _target_coordinates = null
func _act():
	var coordinates = Matrix.get_unit_coordinates(self)
	var neighbors = Matrix.get_neighbors(coordinates)
	var target_unit = neighbors.bottom_neighbor
	if _target_coordinates:
		smash()
		return
	elif target_unit:
		print("ogr ready to smaaaasssh")
		_target_coordinates = Matrix.get_unit_coordinates(target_unit)
		return
		
	straight_move()


func smash():
	print("ogr smaaaaaaaash")
	var cell = Matrix.get_cell(_target_coordinates)
	emit_signal("interact_with_cell", self, cell, "take_damage")
	var neighbors = Matrix.get_neighbors(_target_coordinates)
	var exist_neighbors = neighbors.get_exist_neighbors()
	for neighbor in exist_neighbors:
		if neighbor != self:
			neighbor.change_status(null, "stunned")
	_target_coordinates = null
	return
	
