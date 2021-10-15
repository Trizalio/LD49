extends Node2D
tool

export var allowed_width: int = 100 setget _set_allowed_width
export var title: String = "" setget _set_title
export var description: String = "" setget _set_description

onready var label_node: RichTextLabel = $field/label
var border_width: int = 20


"""
[center]Castle[/center]
[color=#a0ffffff]Units crave to get here at any cost[/color]
"""

func update_label():
	var text = "[center]" + title + "[/center]\n[color=#a0ffffff]" + description + "[/color]"
	if label_node != null:
		label_node.bbcode_text = text

func _set_allowed_width(new_allowed_width: int):
	allowed_width = new_allowed_width
	if label_node != null:
		label_node.rect_min_size.x = allowed_width - border_width

func _set_title(new_title: String):
	title = new_title
	update_label()
	
func _set_description(new_description: String):
	description = new_description
	update_label()
	
func rescale():
	var parent: Control = get_parent()
	var rect: Rect2 = parent.get_rect()
	var field: HBoxContainer = $field
	field.rect_size = rect.size

func _ready():
	rescale()
	update_label()
	get_tree().root.connect("size_changed", self, "rescale")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_extender_item_rect_changed():
	print("alert!")
	pass # Replace with function body.
