extends Status

var hint_ = (
	"Prevents unit from actions for 1 turn"
)

func _init().("Stunned", hint_):
	pass

func on_turn_start() -> bool:
	vanish()
	return false
