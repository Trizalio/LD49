extends Node2D
class_name Unit

var Frozen = preload("res://statuses/frozen.tscn")
var Burning = preload("res://statuses/burning.tscn")
var LightningShield = preload("res://statuses/lightning shield.tscn")


var _status = null
var _race = null
var _tier = null
var _current_status_name = "current_status"

var _stay_frozen_for = 2
var _staid_frozen = 0
 
signal interact(from_unit, to_unit, action)
signal status_changed(unit, action, inst)
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
		
func get_status():
	return _status
	
func move_straight():
	var position =  Matrix.get_unit_coordinates(self)
	if position.x == -1 or position.y == -1:
		return 
	print('move_straight from ', position)
	if _status == "frozen":
		if _staid_frozen < _stay_frozen_for:
			_staid_frozen +=1
			return
		else:
			_staid_frozen = 0
			change_status(self, null)
			
	if Matrix.is_next_to_town(position):
		Matrix.exit_from(position)
		return
	
	var desired_position = position + Vector2(0, 1)
#	print('move_straight desired_position ', desired_position)
	if Matrix.get_cell(desired_position).unit == null:
		Matrix.move_unit(position, desired_position)

func take_damage(from):
	
	print("unit: "  + str(self) + " took damage form" + str(from))
#	if from is Unit:
#		and from != self

	if _status == "lightning_shield":
		print(str(from))
		if from is CenterContainer:
			return
		print("unit: "  + str(self) + " emited lightning_shield" + str(from))
		if from.get_status() != "lightning_shield":
			emit_signal("interact", "lightning_shield", from, "take_damage")
		pass
	else:
		emit_signal("damage_taken", self)
		emit_signal("replace_unit", self, null)


func change_status(from, status):
	print("unit: "  + str(self) + " changed status from " + str(_status) + " to " + str(status) )
	if _status:
		var inst_1 = self.get_node(_current_status_name)
#		self.remove_child(status_node)
		var action_1 = "remove_child"
		emit_signal("status_changed", self, action_1, inst_1, from)
		
	_status = status
	var action = null
	var inst = null
	if status == "frozen":
		inst = Frozen.instance()
		inst.set_name(_current_status_name)
		inst.playing = true
		action = "add_child"
	elif status == "burning":
		inst = Burning.instance()
		inst.set_name(_current_status_name)
		action = "add_child"
	elif status == 'lightning_shield':
		inst = LightningShield.instance()
		inst.set_name(_current_status_name)
		action = "add_child"
#		self.add_child(inst)
	elif status == null:
		inst = self.get_node(_current_status_name)
#		self.remove_child(status_node)
		action = "remove_child"
	else:
		print('Unexpected status')
		assert(false)
	print("emititng status_changed")
	emit_signal("status_changed", self, action, inst, from)
	
	
func interact_to_unit(from_unit: Unit, to_unit: Unit, action: String):
	print("unit: "  + str(from_unit) + " interact to " + str(to_unit) + " action " + str(action) )
	emit_signal("interact", from_unit, to_unit, action)
