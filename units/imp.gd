extends Unit

var hint = (
	'Move: move to one of 3 tiles ahead\n' + 
	'Blocked: swaps with a non-demon on one of the front tiles'
)

func _init().("demon", 1, "imp"):
	pass

func _act():
	print('_act')
	if not nimble_move():
		swap(Rand.choice(MatrixUtils.get_units_by_shifts(self, MatrixUtils.front_3, get_race())))
	
func swap(target_unit):
	if target_unit == null:
		return
	
	var own_cell = Matrix.get_cell(Matrix.get_unit_coordinates(self))
	var target_unit_cell = Matrix.get_cell(Matrix.get_unit_coordinates(target_unit))
	own_cell.unit = target_unit
	target_unit_cell.unit = self
	self_animate("swap", target_unit)

func animate_swap(target_unit):
	print("animate_swap(", self, ", ", target_unit, ")")
	var average_position = (target_unit.position + self.position) / 2
	var delta_position = (target_unit.position - self.position).rotated(deg2rad(90)) * 0.2
	
	var step_duration = GameState.get_rand_animation_duration() / 2
	var self_animation_steps = [
		Animator.AnimationStep.new(average_position + delta_position, step_duration),
		Animator.AnimationStep.new(target_unit.position, step_duration)
	]
	var target_animation_steps = [
		Animator.AnimationStep.new(average_position - delta_position, step_duration),
		Animator.AnimationStep.new(self.position, step_duration)
	]
	self_animation_steps[0].ease_type = Tween.EASE_IN
	target_animation_steps[0].ease_type = Tween.EASE_IN

	Animator.multi_animate(self, "position", self_animation_steps, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	Animator.multi_animate(target_unit, "position", target_animation_steps, Tween.TRANS_CUBIC, Tween.EASE_OUT)
