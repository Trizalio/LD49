extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func drop_data(__, spell):	
	print('drop_data(spell=', spell)
	var name = get_name()
	var destination = Vector2(int(name[0]), int(name[1]))
	GameState.cast_spell(spell, destination)

func can_drop_data(position, data):
	return data is Spell
#	return true
#	# Check position if it is relevant to you
#	# Otherwise, just check data
#	return typeof(data) == TYPE_DICTIONARY and data.has("expected")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
