extends Node2D

func _ready():
	rescale()

func rescale():
	var parent: Control = get_parent()
	var rect: Rect2 = parent.get_rect()
	var field: Control = $field
	field.rect_size = rect.size
	get_tree().root.connect("size_changed", self, "rescale")

func show_spell_hint(spell):
	if spell == null:
		return
		
	visible = true
	$field/hbox/label.bbcode_text = spell.hint
	$field/hbox/cener/background/sprite.frames = spell.get_node('sprite').frames
	
func show_unit_hint(unit):
	if unit == null:
		return
	
	visible = true
	$field/hbox/label.bbcode_text = unit.hint
	$field/hbox/cener/background/sprite.frames = unit.get_node('sprite').frames

func _input(event):
	visible = false
