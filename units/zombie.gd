extends Unit

#var _race = "undead"

func _ready():
	self._race =  "undead"
	
func act():
	print( "zooooooobie acting")
	move_straight()
	
