extends Node2D
class_name Unit

var coordinates = null

func move():
	print("Move")
	

func _to_string():
	return 'Unit(id=' + str(get_instance_id()) + ')' 
#func try_move():

func move_straight():
	var position =  Matrix.get_unit_coordinates(self)
#	print('move_straight from ', position)
	if Matrix.is_next_to_town(position):
		Matrix.exit_from(position)
		return
	
	var desired_position = position + Vector2(0, 1)
#	print('move_straight desired_position ', desired_position)
	if Matrix.get_cell(desired_position).unit == null:
		Matrix.move_unit(position, desired_position)
