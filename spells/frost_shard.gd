extends Spell

var hint = (
	'Spell: Frost shard \n' + 
	'Creates frost shard, blocking path; kills unit, if present'
)

onready var FrostShardUnit = preload("res://units/frost_shard_unit.tscn")

func cast(target_position: Vector2):
	print('cast frost_shard: ', target_position)
	var cell = Matrix.get_cell(target_position)
	if cell.unit != null:
		cell.unit.die()
	Matrix.enter_matrix(target_position, FrostShardUnit.instance())
	return true

func render_targets(target_position: Vector2):
	var targets = SpellTargets.new()
	targets.very_bad_positions = [target_position]
	GameState.game.render_spell_targets(targets)
