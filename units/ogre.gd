extends Unit

var hint = (
	"Move: only straight\n" + 
	"Blocked: attacks any blocking unit and stuns it`s closest neighbours" + 
	"Special: ogre skin is superresistent"
)

func _init().(UnitUtils.Race.Greenskin, 3, "Ogre", hint):
	pass

func _act():
	if straight_move():
		return
		
	var target_unit = Rand.choice(
		MatrixUtils.get_units_by_shifts(self, MatrixUtils.front_1)
	)
	print('target_unit:', target_unit)
	if target_unit:
		print('attack:', target_unit)
		var target_position = Matrix.get_unit_coordinates(target_unit)
		attack(target_unit)
		var all_neighbours = MatrixUtils.get_units_by_shifts(
			target_position, MatrixUtils.all_neighbours)
		print('target_unit all_neighbours:', all_neighbours)
		for neighbour in all_neighbours:
			print('neighbour:', neighbour, ", neighbour != self:", neighbour != self)
			if neighbour != self:
				print('neighbour:', neighbour, ", change_status")
				neighbour.change_status(self, StatusUtils.Stunned(), false)

func _take_damage(damage: Damage.Damage):
	self_animate("got_damage", true)
	
func animate_got_damage(is_weak: bool):
	self.add_child(EffectUtils.GreenCloud())
