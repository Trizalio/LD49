extends Status

var hint_ = (
	"Deals damage at unit`s turn end; " +
	"deals damage if changed with more burning status;" + 
	"cancels frozen status"
)

func _init().("Burning", hint_):
	pass

func animate_appied():
	$sprite.scale = Vector2(0, 0)
	var duration = Rand.float_in_range(0.4, 0.6)
	Animator.animate(self, "scale", Vector2(1, 1), duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)


func on_turn_end() -> bool:
	_owner.take_damage(Damage.damage(Damage.Types.Fire, self))
	return false
	
func on_changed(new_status: Status) -> bool:
	if new_status._name == StatusUtils.Frozen().name:
		vanish()
		return false
	if new_status._name == self._name:
		_owner.take_damage(Damage.damage(Damage.Types.Fire, self))
	return true
