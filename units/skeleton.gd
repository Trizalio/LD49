extends Unit

var hint = (
	'Move: move to one of 3 tiles ahead\n' + 
	"On blocked: wanders around"
)

func _init().("undead", 1, "skeleton", hint):
	pass
	
func _act():
	wander_move()
