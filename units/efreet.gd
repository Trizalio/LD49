extends Unit

var hint = (
	'Move: move to one of 3 tiles ahead\n' + 
	"Killed: spawns imp and inflames all neighbours"
)

func _init().(UnitUtils.Race.Demon, 3, "Efreet", hint):
	pass

func _act():
	nimble_move()

func die_extension(self_position: Vector2, delay: bool = true):
	var new_unit = UnitsGenerator.Imp.instance()
	Matrix.enter_matrix(self_position, new_unit)
	
	for neighbour in MatrixUtils.get_units_by_shifts(self_position, MatrixUtils.all_neighbours):
		neighbour.change_status(self, StatusUtils.Burning(), false)

func animate_death(__):
	var damage_effect = EffectUtils.FireDamage()
#	_interpolate(damage_effect, "scale", Vector2(6, 6))
	self.add_child(damage_effect)
	var duration = GameState.get_rand_animation_duration() * 2
	Animator.animate(damage_effect, "scale", Vector2(6, 6), duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	Animator.animate(self, "modulate", Color(1, 1, 1, 0), duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
#	_interpolate(self, "modulate", Color(1, 1, 1, 0))
	$death.play()
