extends Node2D
class_name Status

var _hint = "<status hint>"
var _applied_on_turn = null
var _owner = null
var _name = "<name>"

func _init(name: String, hint: String = "<hint>"):
	_name = name
	_hint = hint
	
func get_hint() -> String:
	return _hint
	
func _ready():
	call_deferred('animate_applied', null)

func emit_animate(target, method_name, arg=null, delay: bool = true):
	GameState.game.put_into_animate_queue(target, method_name, arg, delay)

func apply(unit):
	_owner = unit
	_applied_on_turn = GameState.turn_number
	on_applied()

func on_applied():
#	emit_animate(self, "applied")
	pass

# false means to end turn, true - to coninue
func on_turn_start() -> bool:
	return true

# false means to end turn, true - to coninue
func on_turn_end() -> bool:
	return false

# false means to take damage, true - ignore damage
func on_take_damage(damage: Damage.Damage) -> bool:
	return true

func _on_changed(new_status) -> bool:
	var remove = on_changed(new_status)
	if remove:
		emit_animate(self, 'on_changed', null, false)
	return remove
		
# false means to not apply new status, true - apply
func on_changed(new_status) -> bool:
	return true

func vanish():
	_owner.change_status(self, null)

###############################
# -> Animate

func animate_applied(__):
	pass

func animate_on_changed(__):
	var parent = get_parent()
	if parent:
		parent.remove_child(self)
