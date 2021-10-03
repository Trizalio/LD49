extends Node

class AnimationStep:
	var start_val = null
	var final_val = null
	var duration = null
	
	func _init(_final_val, _duration: float, _start_val=null):
		start_val = _start_val
		final_val = _final_val
		duration = _duration


func multi_animate(object: Object, property: NodePath, animation_steps: Array, 
					trans_type, ease_type, destroy=false):
	var tween = Tween.new()
	self.add_child(tween)
	tween.connect("tween_completed", self, '_tween_callback', [tween, animation_steps, trans_type, ease_type, destroy])
	_tween_callback(object, property, tween, animation_steps, trans_type, ease_type, destroy)
	
func _tween_callback(object, property, tween: Tween, animation_steps: Array, 
					trans_type, ease_type, destroy: bool):
	if not animation_steps:
		self.remove_child(tween)
		if destroy:
			print("destroy: ", object)
			object.get_parent().remove_child(object)
		return
	var current_step = animation_steps[0]
	animation_steps.remove(0)
	var start_val = current_step.start_val
	if start_val == null:
		start_val = object.get(property)
	tween.interpolate_property(object, property, start_val, 
		current_step.final_val, current_step.duration, trans_type, ease_type)
	tween.start()

func animate(object: Object, property: NodePath, final_val, duration: float, trans_type, ease_type, destroy=false):
	multi_animate(object, property, [AnimationStep.new(final_val, duration)], trans_type, ease_type, destroy)
#
#
#func remove_with_delay(object: Object, delay: float):
#	var tween = Tween.new()
#	self.add_child(tween)
#	tween.interpolate_callback(self, delay, 'remove', tween)
#	tween.start()
#	print('call with delay')
#
#func remove(object: Node, tween: Tween):
#	object.get_parent().remove_child(object)
#	self.remove_child(tween)
#	print('called')
