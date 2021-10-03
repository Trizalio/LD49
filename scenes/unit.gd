extends Node2D
class_name Unit


var _status = null
var _race = null

signal interact(from_unit, to_unit, action)
signal status_changed(unit, status)
signal replace_unit(old_unit, new_unit)

func move():
	print("Move")



func _to_string():
	return 'Unit(id=' + str(get_instance_id()) + ')' 
#func try_move():


func get_race():
	return _race
	
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
	
#	take_damage()

func take_damage():
	
	print(" damage taken for unit: " +  str(self))
	emit_signal("replace_unit", self, null)


func change_status(status):
	_status = status
	emit_signal("status_changed", self, _status)
	
	
func interact_to_unit(from_unit: Unit, to_unit: Unit, action: String):
	emit_signal("interact", from_unit, to_unit, action)
	
	pass
