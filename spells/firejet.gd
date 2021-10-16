extends Spell

var Burning = preload("res://statuses/burning.tscn")
var hint = (
	'Spell: Firejet \n' + 
	'Applies burning to first unit in a column 5 times'
)
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
		print(i, " - ", unit)
		unit.change_status(self,  Burning.instance())	

func render_targets(coords: Vector2):
	var targets = SpellTargets.new()
	for y in range(Matrix.matrix_height):
		targets.very_bad_positions.append(Vector2(coords.x, y))
	GameState.game.render_spell_targets(targets)
