extends TextureRect

onready var draggable = $draggable

func _ready():
	pass
#
#func get_drag_data(position: Vector2):
#	var mydata = make_data()
#	set_drag_preview(make_preview(mydata))
#	return mydata

export (Color, RGBA) var color = Color(1, 0, 0, 1)

func get_drag_data(position):
	# Use a control that is not in the tree
	var draggable_copy = draggable.duplicate()
	draggable_copy.prepare_to_be_dragged()
	set_drag_preview(draggable_copy)
	return draggable_copy

func drop_data(position, data):
	color = data["color"]
	print(color)


func can_drop_data(position, data):
	# Check position if it is relevant to you
	# Otherwise, just check data
	return typeof(data) == TYPE_DICTIONARY and data.has("expected")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
