extends Spell

var chain_lighting_counter = 0
var max_jumps = 5
var _target_race = null
var hint = (
	'Spell: chain lightning \n' + 
	'Deals lightning damage to target and up to 4 more connected units of the same race'
)

func _ready():
	pass # Replace with function body.
	


func cast(coords: Vector2):
	print('cast chain lighting: ', coords)
	
	var unit = Matrix.get_unit(coords)
	if unit == null:
		return false
		
	var target_type = unit.get_race()
	print('target_type: ', target_type)
	var my_damage = Damage.damage(Damage.Types.Lightning, self)
	
	var affected_positions = []
	
	for i in range(max_jumps):
		print('chain step: ', i, ", coords: ", coords)
		Matrix.get_unit(coords).take_damage(my_damage)
		affected_positions.append(coords)
		var positions = MatrixUtils.get_positions_by_shifts_with_units(coords, MatrixUtils.all_neighbours)
		var possible_target_positions = []
		for pos in positions:
			if not (pos in affected_positions) and Matrix.get_unit(pos).get_race() == target_type:
				possible_target_positions.append(pos)
				
		if not possible_target_positions:
			break
			
		coords = Rand.choice(possible_target_positions)
	$ChainLightningSpell.play()	
	return true

func render_targets(coords: Vector2):
	var targets = SpellTargets.new()
#	targets.very_bad_positions = [target_position]

	var unit = Matrix.get_unit(coords)
	if unit == null:
		return false
	var target_type = unit.get_race()
	var affected_positions = []
	for i in range(max_jumps):
		affected_positions.append(coords)
		var positions = MatrixUtils.get_positions_by_shifts_with_units(coords, MatrixUtils.all_neighbours)
		var possible_target_positions = []
		for pos in positions:
			if not (pos in affected_positions) and Matrix.get_unit(pos).get_race() == target_type:
				possible_target_positions.append(pos)
				
		if not possible_target_positions:
			break
			
		coords = Rand.choice(possible_target_positions)
	targets.very_bad_positions = affected_positions
	GameState.game.render_spell_targets(targets)
