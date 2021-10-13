extends Status
var hint_ = (
	"protects from most damage types and deals lightning damage if attacked; " +
	"explodes on lightning damage"
)
func _init().("Lightning shield", hint_):
	pass
	
func on_take_damage(damage: Damage.Damage) -> bool:
	var my_damage = Damage.damage(Damage.Types.Lightning, self)
	if damage.type == Damage.Types.Lightning:
		my_damage.delay = false
		var neighbour_positions = MatrixUtils.filter_existent_positions(
			MatrixUtils.shift_by(
				Matrix.get_unit_coordinates(_owner), 
				MatrixUtils.all_neighbours
			)
		)
		emit_animate(self, "explosion")
		
		_owner.die()
		for position in neighbour_positions:
			var neighbour = Matrix.get_cell(position).unit
			if neighbour != null:
				neighbour.take_damage(my_damage)
		return true
		
	if damage.attacker != null:
		damage.attacker.take_damage(my_damage)
	return false

func animate_explosion(__):
	var duration = GameState.get_rand_animation_duration()
	Animator.animate(self, "scale", Vector2(3, 3), duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	Animator.animate(self, "modulate", Color(1, 1, 1, 0), duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, true)
	
