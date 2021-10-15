extends Spell

var Burning = preload("res://statuses/burning.tscn")
var hint = ('Spell: fireball \nProperties: kills unit on the tile')

func _ready():
	pass # Replace with function body.

func cast(target_position: Vector2):
	print('cast fireball: ', target_position)
	var target_unit = Matrix.get_unit(target_position)
	if target_unit == null:
		return false
	
	target_unit.take_damage (Damage.damage(Damage.Types.Fire, self))
	
	var coords = target_position
	for neighbour in [target_unit] + MatrixUtils.get_units_by_shifts(coords, MatrixUtils.all_neighbours):
		neighbour.change_status(self, Burning.instance())
	
#	$FireballSpell.play()
	return true
