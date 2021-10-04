extends Spell
onready var FrostShardUnit = preload("res://units/frost_shard_unit.tscn")

func cast(target_position: Vector2):
	
	print('cast frost_shard: ', target_position)
	Matrix.enter_matrix(target_position, FrostShardUnit.instance())
	
