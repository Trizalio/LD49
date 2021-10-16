extends Spell

var hint = (
	'Spell: Lightning shield \n' + 
	'Provides target unit with lightning shield'
)


var LightningShield = preload("res://statuses/lightning shield.tscn")

func _ready():
	pass # Replace with function body.

func cast(target_position: Vector2):
	print('cast lightning_shield: ', target_position)
	
	var target_unit = Matrix.get_cell(target_position).unit
	if target_unit == null:
		return false

	var done = target_unit.change_status(self, LightningShield.instance())
	return done

func render_targets(target_position: Vector2):
	var targets = SpellTargets.new()
	targets.good_positions = [target_position]
	GameState.game.render_spell_targets(targets)
