extends TextureRect
class_name Tile

signal hover
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_my_posiiton() -> Vector2:
	var name = get_name()
	var position = Vector2(int(name[0]), int(name[1]))
	return position

func drop_data(__, spell):	
	print('drop_data(spell=', spell)
	GameState.cast_spell(spell, get_my_posiiton())

func can_drop_data(position, data):
	if data is Spell:
		data.render_targets(get_my_posiiton())
	return data is Spell
#	return true
#	# Check position if it is relevant to you
#	# Otherwise, just check data
#	return typeof(data) == TYPE_DICTIONARY and data.has("expected")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_background_mouse_entered():
	$timer.start()
	pass # Replace with function body.


func _on_background_mouse_exited():
	$timer.stop()
	pass # Replace with function body.


func _on_Timer_timeout():
	print('show hint')
	emit_signal('hover')
	pass # Replace with function body.
