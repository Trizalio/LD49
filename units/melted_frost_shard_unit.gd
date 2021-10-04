extends Unit

var hint = ('Spell: melted frost shard \nProperties: closes the way through the tile')

var _turn_counter = 0
var _replace_after_turn = 1
func _ready():
	self._race =  "melted_frost_shard_unit"
	self._tier =  0

func get_race():
	return "melted_frost_shard_unit"

func get_tier():
	return 0
	
func _act():
	
#	if _turn_counter >= _replace_after_turn:
	emit_signal("replace_unit", self, null)
#	else:
#		_turn_counter +=1
	
