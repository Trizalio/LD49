extends Node2D
class_name Unit

var Frozen = preload("res://statuses/frozen.tscn")
var Burning = preload("res://statuses/burning.tscn")

var _status = null
var _race = null
var _tier = null

signal interact(from_unit, to_unit, action)
signal status_changed(unit, status)
signal replace_unit(old_unit, new_unit)
signal damage_taken(unit)

func move():
	print("Move")



func _to_string():
	return 'Unit(id=' + str(get_instance_id()) + ')' 
#func try_move():


func get_race():
	return _race
	
func get_tier():
	return _tier
	
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

func take_damage():
	
	print("unit: "  + str(self) + " took damage")
	emit_signal("damage_taken", self)
	emit_signal("replace_unit", self, null)


func change_status(status):
	print("unit: "  + str(self) + " changed status from " + str(_status) + " to " + (status) )
	_status = status
	if status == "frozen":
		var inst = Frozen.instance()
		inst.playing = true
		self.add_child(inst)
	if status == "burning":
		var inst = Burning.instance()
		self.add_child(inst)
	emit_signal("status_changed", self, _status)
	
	
func interact_to_unit(from_unit: Unit, to_unit: Unit, action: String):
	print("unit: "  + str(from_unit) + " interact to " + str(to_unit) + " action " + str(action) )
	emit_signal("interact", from_unit, to_unit, action)
