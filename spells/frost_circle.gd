extends Spell

var Frozen = preload("res://statuses/frozen.tscn")
var hint = ('Spell: frost circle \nProperties: kills units in a circle from the selected tile')

func _ready():
	pass # Replace with function body.

func cast(target_position: Vector2):
	print('cast frost_circle: ', target_position)
	for neighbour in MatrixUtils.get_units_by_shifts(target_position, MatrixUtils.all_neighbours):
		neighbour.change_status(self, Frozen.instance(), false)
	
	GameState.game.put_into_animate_queue(self, 'wait', null)
	return true

func render_targets(coords: Vector2):
	var targets = SpellTargets.new()
	targets.bad_positions = MatrixUtils.get_positions_by_shifts(coords, MatrixUtils.all_neighbours)
	GameState.game.render_spell_targets(targets)
