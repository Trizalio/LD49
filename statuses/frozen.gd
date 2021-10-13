extends Status

var hint_ = (
	"Deals damage at unit`s turn end; " +
	"deals damage if changed with more burning status;" + 
	"cancels frozen status"
)

func _init().("Frozen", hint_):
	pass

func animate_applied(__):
	print('animate_applied')
	$sprite.play()
	pass

func on_turn_start() -> bool:
	vanish()
	return false
