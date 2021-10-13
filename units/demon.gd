extends Unit

var hint = (
	'Move: move to one of 3 tiles ahead\n' + 
	'Blocked: inflames one of not burning neighbours, prioritizes demons'
)

func _init().(UnitUtils.Race.Demon, 2, "demon"):
	pass

func _act():
	if nimble_move():
		return
	
	var neighbours = MatrixUtils.get_units_by_shifts(self, MatrixUtils.all_neighbours)
	var target = (
		Rand.choice(MatrixUtils.filter_units__only_race(neighbours, get_race())) 
		or 
		Rand.choice(MatrixUtils.filter_units__exclude_race(neighbours, get_race()))
	)
	apply_status(target, StatusUtils.Burning())
