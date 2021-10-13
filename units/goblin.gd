extends Unit

var hint = (
	"Move: only straight\n" +
	"Sprint: can move two times in a row\n" + 
	"Blocked: attack unit in front (even other greenskins)"
)

func _init().("greenskin", 1, "goblin"):
	pass

func _ready():
	pass
	
func _act():
	if straight_move():
		straight_move()
	else:
		attack(MatrixUtils.get_units_by_shifts(self, MatrixUtils.front_1)[0])
	
