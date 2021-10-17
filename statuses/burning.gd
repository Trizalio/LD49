extends Status

var hint_ = (
	"Deals damage at unit`s turn end; " +
	"deals damage if changed with more burning status;" + 
	"cancels frozen status"
)

func _init().("Burning", hint_):
	pass

func on_turn_end() -> bool:
	_owner.take_damage(Damage.damage(Damage.Types.Fire, self))
	return false
	
func on_changed(new_status: Status) -> bool:
	if new_status != null and new_status._name == StatusUtils.Frozen()._name:
		vanish()
		return false
	if new_status != null and new_status._name == self._name:
		_owner.take_damage(Damage.damage(Damage.Types.Fire, self))
	return true
