extends Unit

var hint = (
	'Move: move to one of 3 tiles ahead\n' + 
	"Blocked: attacks enemy in front 3 tiles"
)

func _init().("greenskin", 1, "goblin", hint):
	pass

func _ready():
	pass
	
func _act():
	if not nimble_move():
		var target_unit = Rand.choice(
			MatrixUtils.get_units_by_shifts(
				self, MatrixUtils.front_3, self.get_race()
		))
		if target_unit:
			attack(target_unit)
#			self_animate()
#			target_unit.take_damage(Damage.damage(Damage.Types.Physical, self))
			
