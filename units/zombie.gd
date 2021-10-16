extends Unit


var hint = (
	'Move: move to one of 3 tiles ahead\n' + 
	"On blocked: wanders around\n" +
	"On killed: spawns skeleton"
) 

func _init().("undead", 2, "zombie", hint):
	pass

func _act():
	wander_move()
	return

func die_extension(self_position: Vector2, delay: bool = true):
	var new_unit = UnitsGenerator.UndeadSkeleton.instance()
	Matrix.enter_matrix(self_position, new_unit)
