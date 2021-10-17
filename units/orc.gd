extends Unit

var hint = (
	'Move: move to one of 3 tiles ahead\n' + 
	"Blocked: attacks enemy in front 3 tiles"
)

func _init().(UnitUtils.Race.Greenskin, 2, "Orc", hint):
	pass

func _ready():
	pass
	
func _act():
	if nimble_move():
		return
	var target_unit = Rand.choice(
		MatrixUtils.get_units_by_shifts(
			self, MatrixUtils.front_3, self.get_race()
	))
	if target_unit:
		attack(target_unit)
