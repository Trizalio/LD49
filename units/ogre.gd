extends Unit

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
	print("ogr target_unit" + str(target_unit))
	if _target_coordinates:
		print(" before cell_interacted emit")
		var cell = Matrix.get_cell(_target_coordinates)
		emit_signal("interact_with_cell", self, cell, "smash")
		_target_coordinates = null
		return
	elif target_unit:
		print(" ready to smaaaasssh")
		_target_coordinates = Matrix.get_unit_coordinates(target_unit)
		return
		
	move_straight()


#func smash()
