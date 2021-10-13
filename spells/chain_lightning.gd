extends Spell

var chain_lighting_counter = 0
var max_jumps = 5
var _target_race = null

func _ready():
	pass # Replace with function body.

func cast(coords: Vector2):
	print('cast chain lighting: ', coords)
	
	var unit = Matrix.get_unit(coords)
	if unit == null:
		return false
		
	var target_type = unit.get_type_name()
	print('target_type: ', target_type)
	var my_damage = Damage.damage(Damage.Types.Lightning, self)
	
	var affected_positions = []
	
	for i in range(max_jumps):
		print('chain step: ', i, ", coords: ", coords)
		Matrix.get_unit(coords).take_damage(my_damage)
		var positions = MatrixUtils.shift_by(coords, MatrixUtils.all_neighbours)
		positions = MatrixUtils.filter_existent_positions(positions)
		var possible_target_positions = []
		for pos in positions:
			print('pos: ', pos)
			if pos in affected_positions:
				print('skip affected:', pos)
				continue
			var posiible_unit = Matrix.get_unit(pos)
			print('posiible_unit:', posiible_unit)
			if posiible_unit != null:
				print('posiible_unit:', posiible_unit)
				if posiible_unit.get_type_name() == target_type:
					possible_target_positions.append(pos)
				
		print('possible_target_positions:', possible_target_positions)
		if not possible_target_positions:
			return
			
		coords = Rand.choice(possible_target_positions)
		
	return true
