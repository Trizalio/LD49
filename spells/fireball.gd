extends Spell

var Burning = preload("res://statuses/burning.tscn")
var hint = (
	'Spell: Fireball \n' + 
	'Deals fire damage to target, ignites it and all neighbours'
)

func _ready():
	pass # Replace with function body.

func cast(target_position: Vector2):
	print('cast fireball: ', target_position)
	var target_unit = Matrix.get_unit(target_position)
	var unit_to_burn = MatrixUtils.get_units_by_shifts(target_position, MatrixUtils.all_neighbours)
	if target_unit != null:
		target_unit.take_damage(Damage.damage(Damage.Types.Fire, self))
		unit_to_burn = [target_unit] + unit_to_burn
	
	for neighbour in unit_to_burn:
		neighbour.change_status(self, Burning.instance(), false)
	
	GameState.game.put_into_animate_queue(self, 'wait', null)
#	$FireballSpell.play()
	return true


func render_targets(coords: Vector2):
	var targets = SpellTargets.new()
	targets.very_bad_positions = [coords]
	targets.bad_positions = MatrixUtils.get_positions_by_shifts(coords, MatrixUtils.all_neighbours)
	GameState.game.render_spell_targets(targets)
