extends MarginContainer

func show_unit_hint(unit):
	if unit == null:
		return
	
	visible = true
	$parts/margin2/hint_text.bbcode_text = unit.hint
	$parts/margin/background/sprite.frames = unit.get_node('sprite').frames
	
func _input(event):
	visible = false
