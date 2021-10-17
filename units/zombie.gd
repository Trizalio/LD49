extends Unit


var hint = (
	'Move: move to one of 3 tiles ahead\n' + 
	"Blocked: wanders around\n" +
	"Killed: spawns skeleton"
) 

func _init().(UnitUtils.Race.Undead, 2, "Zombie", hint):
	pass

func _act():
	wander_move()
	return

func die_extension(self_position: Vector2, delay: bool = true):
	var new_unit = UnitsGenerator.UndeadSkeleton.instance()
	Matrix.enter_matrix(self_position, new_unit)
