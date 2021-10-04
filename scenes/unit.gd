extends Node2D
class_name Unit

var Frozen = preload("res://statuses/frozen.tscn")
var Burning = preload("res://statuses/burning.tscn")
var LightningShield = preload("res://statuses/lightning shield.tscn")


var _status = null
var _race = null
var _tier = null
var _current_status_name = "current_status"

var _stay_frozen_for = 5
var _staid_frozen = 0
 
signal interact(from_unit, to_unit, action)
signal status_changed(unit, action, inst)
signal replace_unit(old_unit, new_unit)
signal damage_taken(unit)
signal interact_with_cell(from, to_cell, action)

func move():
	print("Move")

##############################################
# --> power_move

func shift_by(position: Vector2, shifts: Array) -> Array:
	var results: Array = []
	for shift in shifts:
		assert(shift is Vector2)
		results.append(position + shift)
	return results

var right = Vector2(1, 0)
var bot = Vector2(0, 1)
var left = -right
var top = -bot

func filter_existent_positions(positions: Array) -> Array:
	var results: Array = []
	for pos in positions:
		
		results.append(pos)
	return results

func filter_positions(positions: Array) -> Array:
	var results: Array = []
	for pos in positions:
		if pos.x < 0 or pos.y < 0:
			continue
		if pos.x >= Matrix.matrix_width or pos.y >= Matrix.matrix_height:
			continue
		if Matrix.get_cell(pos).unit != null:
			continue
		results.append(pos)
	return results

func power_move(best_shifts: Array, other_shifts: Array) -> bool:
	var pos = Matrix.get_unit_coordinates(self)
	if Matrix.is_next_to_town(pos):
		Matrix.exit_from(pos)
		return true
	
	var target_position = null
	var best_positions = filter_positions(shift_by(pos, best_shifts))
	if best_positions:
		print('power_move from ', pos, ' to best_positions:', best_positions)
		target_position = Rand.rand_choice(best_positions)
	
	if target_position == null:
		var other_positions = filter_positions(shift_by(pos, other_shifts))
		if other_positions:
			print('power_move from ', pos, ' to best_positions:', other_positions)
			target_position = Rand.rand_choice(other_positions)
		
	if target_position:
		Matrix.move_unit(pos, target_position)
		return true
	return false

func wander_move() -> bool:
	print('wander_move')
	var best_shifts = [bot + left, bot, bot + right]
	var other_shifts = [left, left + top, top, right + top, right]
	return power_move(best_shifts, other_shifts)

func nimble_move() -> bool:
	var best_shifts = [bot + left, bot, bot + right]
	var other_shifts = []
	return power_move(best_shifts, other_shifts)
	
func straight_move() -> bool:
	var best_shifts = [bot]
	var other_shifts = []
	return power_move(best_shifts, other_shifts)
	
# <-- power_move
##############################################


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
	
			
	if Matrix.is_next_to_town(position):
		Matrix.exit_from(position)
		return
	
	var desired_position = position + Vector2(0, 1)
#	print('move_straight desired_position ', desired_position)
	if Matrix.get_cell(desired_position).unit == null:
		Matrix.move_unit(position, desired_position)
		
func check_status():
	if _status == "frozen":
		return false
	return true

func interact_status():
	if _status == "frozen":
		if _staid_frozen < _stay_frozen_for:
			_staid_frozen +=1
			return
		else:
			_staid_frozen = 0
			change_status(self, null)
	elif _status == "burning":
		take_damage("burning")
		
	
	pass

#func _do_act(unit, action_name):
#	if self.check_status():
#		unit.call(action_name)
#	self.interact_status()
func act():
	if self.check_status():
		_act()
	self.interact_status()

func _act():
	pass

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
	elif status == "stunned":
		print("unit stunned")
		inst = Burning.instance()
		inst.set_name(_current_status_name)
		action = "add_child"
		
	else:
		print('Unexpected status')
		assert(false)
	print("emititng status_changed for: " + str(self))
	emit_signal("status_changed", self, action, inst, from)
	
	
func interact_to_unit(from_unit: Unit, to_unit: Unit, action: String):
	print("unit: "  + str(from_unit) + " interact to " + str(to_unit) + " action " + str(action) )
	emit_signal("interact", from_unit, to_unit, action)	
	
func interact_to_cell(from_unit: Unit, to_cell: Unit, action: String):
	print("unit: "  + str(from_unit) + " interact to " + str(to_cell) + " action " + str(action) )
	emit_signal("interact_with_cell", from_unit, to_cell, action)
