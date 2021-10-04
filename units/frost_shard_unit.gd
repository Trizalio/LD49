extends Unit
var _turn_counter = 0
var _replace_after_turn = 1
func _ready():
	self._race =  "frost_shard_unit"
	self._tier =  0

func get_race():
	return "frost_shard_unit"

func get_tier():
	return 0
	
func _act():
#	var inst = MeltedFrostShardUnit.instance()
	print("frost_shard_unit acting", _turn_counter)
	if _turn_counter >= _replace_after_turn:
		var position = Matrix.get_unit_coordinates(self)
		print(" turn into demon")
		var inst = UnitsGenerator.MeltedFrostShardUnit.instance()
		emit_signal("replace_unit", self, null)
#		emit_signal("replace_unit", self, inst)
		Matrix.enter_matrix(position, inst)
	else:
		_turn_counter +=1
	
