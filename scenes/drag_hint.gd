extends Sprite

func move_to(target_position: Vector2, duration: float):
	print('move_to: ', target_position)
	var step_duration = duration / 2.5
	var steps = [
		Animator.AnimationStep.new(Color(1, 1, 1, 1), step_duration / 2),
		Animator.AnimationStep.new(target_position, step_duration),
		Animator.AnimationStep.new(Color(1, 1, 1, 0), step_duration / 2),
	]
	steps[0].property = "modulate"
	steps[1].property = "position"
	steps[2].property = "modulate"
	Animator.multi_animate(self, "modulate", steps, Tween.TRANS_SINE, Tween.EASE_IN_OUT, true)
