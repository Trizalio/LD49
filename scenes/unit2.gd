extends TextureRect
const NeighborsClass = preload("res://utils/unit_neighbors.gd")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum {STRAIGHT, ANY_FREE}


class Unitt:
	
	var _unit_type  = null
	var _status_effect = null 
	var _strategy = null
	
	func _init(unit_type, status_effect = null, move_strategi = STRAIGHT):
		_unit_type = unit_type
		_status_effect = status_effect
		_strategy = move_strategi
		
		
	func act():
		print( "_in act")
		var coordinates =  Matrix.get_unit_coordinates(self)
		if Matrix.is_next_to_town(coordinates[0]):
			Matrix.move_to_town(coordinates[0], coordinates[1])
			return
			
		var neighbors  = Matrix.get_neighbors(coordinates[0], coordinates[1])
#		move(coordinates, neighbors)
	
	func move(coordinates, neighbors):
		if _strategy == STRAIGHT:
			if not neighbors.bottom_neighbor:
				Matrix.move_to(coordinates[0], coordinates[1],
				 coordinates[0] + 1, coordinates[1])
		elif _strategy == ANY_FREE:
			if not neighbors.bottom_left_neighbor:
				Matrix.move_to(coordinates[0], coordinates[1],
				 coordinates[0] + 1, coordinates[1] - 1)
				
			elif not neighbors.bottom_neighbor:
				Matrix.move_to(coordinates[0], coordinates[1],
				 coordinates[0] + 1, coordinates[1])
				
			elif not neighbors.bottom_right_neighbor:
				Matrix.move_to(coordinates[0], coordinates[1],
				 coordinates[0] + 1, coordinates[1] + 1)
			


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
