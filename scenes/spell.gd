extends TextureRect
class_name Spell

var is_dragged = false

func _ready():
	var sprite = $sprite
	if is_dragged:
		sprite.set_position(Vector2())
		sprite.set_centered(true)
		set_self_modulate(Color(1, 1, 1, 0))
	else:
		sprite.set_position(get_rect().size / 2)
		sprite.set_centered(true)
		set_self_modulate(Color(1, 1, 1, 1))

func prepare_to_be_dragged():
	is_dragged = true

func get_drag_data(position):
	# Use a control that is not in the tree
	var draggable_copy = duplicate()
	draggable_copy.prepare_to_be_dragged()
	set_drag_preview(draggable_copy)
	return self

func cast(target_position: Vector2):
	print('cast: ', target_position)
	pass
	
