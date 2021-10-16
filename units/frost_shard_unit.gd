extends Unit

var hint = 'Does not mov.\nMelts turn by turn.'
var _lifespan = 1
var _state = 0

func _init().(UnitUtils.Race.Special, 0, "Frost shard"):
	_state = 0


func change_status(reason, status: Status, delay: bool = true) -> bool:
	print('change_status: ', status._name, " ? ", StatusUtils.Burning()._name)
	if status._name == StatusUtils.Burning()._name:
		melt()
		
	if status._name == StatusUtils.Frozen()._name:
		fortify()
		
	return false

func change_state():
	if _state <= 1:
		emit_animate(self, "change_state", _state)
	else:
		die()
	

func melt():
	_state = min(2, _state + 1)
	change_state()
		
	
func fortify():
	_state = max(0, _state - 1)	
	change_state()

func _act():
	melt()

func animate_change_state(state):
	$sprite.frame = state
