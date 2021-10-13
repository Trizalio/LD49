extends Spell

var Burning = preload("res://statuses/burning.tscn")
var hint = ('Spell: fireball \nProperties: kills units in column')
var charges: int = 5

func _ready():
	pass # Replace with function body.
	
func find_first_unit_in_column(x: int):
	for y in range(Matrix.matrix_height -1, -1, -1):
		var target_unit = Matrix.get_unit(Vector2(x, y))
		if target_unit != null:
			return target_unit
	return null

func cast(target_position: Vector2):
	print('cast firejet: ', target_position)
	for i in range(charges):
		var unit = find_first_unit_in_column(target_position.x)
		if unit == null:
			break
		unit.change_status(self,  Burning.instance())	
	
