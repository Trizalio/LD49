extends Unit

var hint = 'Does not mov.\nMelts turn by turn.'
var _lifespan = 1
var _state = 0

func _init().(UnitUtils.Race.Special, 0, "Frost shard"):
	_state = 0

func _act():
	if _state == 0:
		_state += 1
		emit_animate(self, "change_state", _state)
	else:
		die()

func animate_change_state(state):
	$sprite.frame = state
