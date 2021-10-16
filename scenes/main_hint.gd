extends Node2D

func _ready():
	rescale()

func rescale():
	var parent: Control = get_parent()
	var rect: Rect2 = parent.get_rect()
	var field: Control = $field
	field.rect_size = rect.size
	get_tree().root.connect("size_changed", self, "rescale")
#	call_deferred("rescale")

func show_spell_hint(spell):
	if spell == null:
		return
		
	visible = true
	$field/vbox/unit_or_spell/label.bbcode_text = spell.hint
	$field/vbox/unit_or_spell/cener/background/sprite.frames = spell.get_node('sprite').frames
	$field/vbox/status.visible = false
	
func show_unit_hint(unit):
	if unit == null:
		return
	
	visible = true
	$field/vbox/unit_or_spell/label.bbcode_text = unit.get_hint()
	$field/vbox/unit_or_spell/cener/background/sprite.frames = unit.get_node('sprite').frames
	
	var status = unit.get_status()
	if status != null:
		$field/vbox/status.visible = true
		$field/vbox/status/label.bbcode_text = status.get_hint()
		var background = $field/vbox/status/cener/background
		for child in background.get_children():
			background.remove_child(child)
		var status_copy = status.duplicate()
		background.add_child(status_copy)
		status_copy.position = background.rect_size / 2
	else:
		$field/vbox/status.visible = false

func _input(event):
	visible = false
