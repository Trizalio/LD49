extends Control
class_name Spell

var is_dragged = false
export var is_enabled: bool = true setget _set_is_enabled

func _set_is_enabled(new_is_enabled: bool):
	is_enabled = new_is_enabled
	self.modulate = Color(1, 1, 1, 0.5 + 0.5 * int(is_enabled))

func _ready():
	var sprite = $sprite
	if is_dragged:
		sprite.set_position(Vector2())
		sprite.set_centered(true)
		$background.set_self_modulate(Color(1, 1, 1, 0))
	else:
		sprite.set_position(get_rect().size / 2)
		sprite.set_centered(true)

func prepare_to_be_dragged():
	is_dragged = true

func get_drag_data(position):
	if not is_enabled:
		return null
#	return null
	# Use a control that is not in the tree
	var draggable_copy = duplicate()
	draggable_copy.prepare_to_be_dragged()
	set_drag_preview(draggable_copy)
	return self

func cast(target_position: Vector2):
	print('cast: ', target_position)
	pass

func _cast(target_position: Vector2):
	var result = cast(target_position)
	GameState.game.render_spell_targets(SpellTargets.new())
	return result
	
func animate_wait(__):
	pass


class SpellTargets:
	var very_bad_positions: Array = []
	var bad_positions: Array = []
	var good_positions: Array = []
	var very_good_positions: Array = []
	
	func _init():
		pass
	

func render_targets(target_position: Vector2):
	pass
#	var targets = GameState.game.SpellTargets.new()
#	targets.good_positions = [target_position]
#	GameState.game.render_spell_targets(targets)
