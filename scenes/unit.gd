extends Node2D
class_name Unit

var Frozen = preload("res://statuses/frozen.tscn")

var _status = null
var _race = null
var _tier = null
var _type_name: String = 'Unit'
var _current_status_name = "current_status"

var _stay_frozen_for = 5
var _staid_frozen = 0
var _created_on_turn = null
var _acted_at_turn = null
var _dead = false
 
signal interact(from_unit, to_unit, action)
signal status_changed(unit, action, inst)
signal replace_unit(old_unit, new_unit)
signal damage_taken(unit)
signal interact_with_cell(from, to_cell, action)

#signal change_status(unit, new_status)
signal animate(target, method_name, arg)

##############################################
# --> power_move

func move(target_position):
	Matrix.get_cell(Matrix.get_unit_coordinates(self)).unit  = null
	Matrix.get_cell(target_position).unit = self
	emit_animate(self, "move", target_position)

func exit():
	Matrix.get_cell(Matrix.get_unit_coordinates(self)).unit = null

func power_move(best_shifts: Array, other_shifts: Array) -> bool:
	var pos = Matrix.get_unit_coordinates(self)
	if Matrix.is_next_to_town(pos):
		emit_animate(self, "exit")
		exit()
#		Matrix.exit_from(pos)
		return true
	
	var target_position = null
	var best_positions = MatrixUtils.filter_empty_existent_positions(MatrixUtils.shift_by(pos, best_shifts))
	if best_positions:
#		print('power_move from ', pos, ' to best_positions:', best_positions)
		target_position = Rand.choice(best_positions)
	
	if target_position == null:
		var other_positions = MatrixUtils.filter_empty_existent_positions(MatrixUtils.shift_by(pos, other_shifts))
		if other_positions:
#			print('power_move from ', pos, ' to other_positions:', other_positions)
			target_position = Rand.choice(other_positions)
		
	if target_position:
		move(target_position)
#		Matrix.move_unit(pos, target_position)
		return true
	return false


var wander_best_shifts = MatrixUtils.front_3
var wander_other_shifts = Utils.set_diff(MatrixUtils.all_neighbours, wander_best_shifts)
func wander_move() -> bool:
	return power_move(wander_best_shifts, wander_other_shifts)

var nimble_best_shifts = MatrixUtils.front_1
var nimble_other_shifts = Utils.set_diff(MatrixUtils.front_3, nimble_best_shifts)
func nimble_move() -> bool:
	print('nimble_move')
	return power_move(nimble_best_shifts, nimble_other_shifts)
	
var straight_best_shifts = [MatrixUtils.front_1]
var straight_other_shifts = []
func straight_move() -> bool:
	return power_move(straight_best_shifts, straight_other_shifts)
	
# <-- power_move
##############################################

func _to_string():
	return _type_name + '(id=' + str(get_instance_id()) + ')' 

func _init(race, tier, type_name):
	self._created_on_turn = GameState.turn_number
	self._race = race
	self._tier = tier
	self._type_name =  type_name
	self._acted_at_turn = GameState.turn_number
	self._status = StatusUtils.Normal()
	self._status.name = STATUS_NAME

func get_race():
	return _race
	
func get_type_name() -> String:
	return _type_name
	
func get_tier():
	return _tier
		
func get_status():
	return _status
	
func act():
	print('act, _acted_at_turn: ', _acted_at_turn, ", GameState.turn_number:", GameState.turn_number)
	if _acted_at_turn < GameState.turn_number:
		_acted_at_turn = GameState.turn_number
		
		if _status.on_turn_start():
			_act()
		if _status.on_turn_end():
			_act()

func _act():
	pass

func take_damage(damage: Damage.Damage):
#	print("unit: "  + str(self) + " took damage:" + str(damage))
	if damage.type == Damage.Types.Lightning:
		self_animate("take_lightning_damage", null, damage.delay)
	if _status.on_take_damage(damage):
		die(damage.delay)
#		emit_signal("damage_taken", damage)
#		emit_signal("replace_unit", self, null)


func change_status(reason, status: Status) -> bool:
	if _status.on_changed(status):
#		print("unit: "  + str(self) + " changed status from " + str(_status) + " to " + str(status) )
		emit_animate(self, "change_status", status)
		_status = status
		_status.apply(self)
		return true
	return false
#
#func interact_to_unit(from_unit: Unit, to_unit: Unit, action: String):
#	print("unit: "  + str(from_unit) + " interact to " + str(to_unit) + " action " + str(action) )
#	emit_signal("interact", from_unit, to_unit, action)	
#
#func interact_to_cell(from_unit: Unit, to_cell: Unit, action: String):
#	print("unit: "  + str(from_unit) + " interact to " + str(to_cell) + " action " + str(action) )
#	emit_signal("interact_with_cell", from_unit, to_cell, action)
	
func emit_animate(target, method_name, arg=null, wait: bool = true):
	GameState.game.put_into_animate_queue(target, method_name, arg, wait)
#	emit_signal("animate", target, method_name, arg)

func self_animate(method_name, arg=null, wait: bool = true):
	emit_animate(self, method_name, arg, wait)
	

func attack(target_unit):
	if target_unit == null:
		return
	emit_animate(self, "interact", target_unit)
	target_unit.take_damage(Damage.damage(Damage.Types.Physical, self))

func apply_status(target_unit, status):
	if target_unit == null or status == null:
		return
		
	emit_animate(self, "interact", target_unit)
	if target_unit.change_status(status):
		emit_animate(status, "appied")
#
#func change_state(target_unit, new_state):
#	if target_unit == null:
#		return 
#
#	target_unit.change_state(new_state)
#	emit_animate(target_unit, "change_state")

func die(delay: bool = true):
	if _dead:
		return
	_dead = true
	Matrix.get_cell(Matrix.get_unit_coordinates(self)).unit = null
	emit_animate(self, "death", null, delay)

###########################################################################

func on_enter_matrix():
	emit_animate(self, "enter_matrix")

###########################################################################
# --> animations

func matrix_to_map(matrix_position: Vector2) -> Vector2:
	return GameState.game.matrix_to_map(matrix_position)

func _interpolate(object: Object, property: NodePath, final_val, destroy:bool = false):
	var duration = GameState.get_rand_animation_duration()
	Animator.animate(object, property, final_val, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, destroy)
	
func _multi_interpolate(object: Object, property: NodePath, values: Array, destroy:bool = false):
	var animation_steps = []
	for val in values:
		animation_steps.append(Animator.AnimationStep.new(val, GameState.get_rand_animation_duration()))
	Animator.multi_animate(object, property, animation_steps, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, destroy)

func animate_death(__):
	_interpolate(self, "modulate", Color(1, 1, 1, 0))

func animate_interact(target_cell_or_unit):
	var target_position = null
	if target_cell_or_unit is Node2D:
		target_position = target_cell_or_unit.get_position()
	elif target_cell_or_unit is Matrix.Cell:
		target_position = matrix_to_map(target_cell_or_unit.get_coordinates())

	var start_position = self.get_position()
	var first_step = (target_position * 2 + start_position) / 3
		
	_multi_interpolate(self, "position", [first_step, start_position])
	
func animate_move(target_cell_or_position):
	var target_cell = null
	if target_cell_or_position is Vector2:
		target_cell = Matrix.get_cell(target_cell_or_position)
	elif target_cell_or_position is Matrix.Cell:
		target_cell = target_cell_or_position
	else:
		assert(false, "animate_move got: " + str(target_cell_or_position))
	_interpolate(self, "position", matrix_to_map(target_cell.get_coordinates()))
	
var STATUS_NAME = "status"
func animate_change_status(new_status: Status):
	remove_child(get_node(STATUS_NAME))
	new_status.name = STATUS_NAME
	add_child(new_status)
	
func animate_enter_matrix(__):
	print('animate_enter_matrix')
	GameState.game.append_unit(self)
	self.position = matrix_to_map(Matrix.get_unit_coordinates(self))
	self.modulate = Color(1, 1, 1, 0)
	_interpolate(self, "modulate", Color(1, 1, 1, 1))

func animate_exit(__):
	_interpolate(self, "modulate", Color(1, 1, 1, 0), true)
	
func animate_take_lightning_damage(__):
	self.add_child(EffectUtils.LightningDamage())
