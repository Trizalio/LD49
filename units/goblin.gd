extends Unit

var hint = (
	"Move: only straight\n" + 
	"Sprint: can move two times in a row"
)

func _init().("greenskin", 1, "goblin", hint):
	pass

func _ready():
	pass
	
func _act():
	if straight_move():
		straight_move()
