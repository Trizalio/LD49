extends Spell


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func cast(target_position: Vector2):
	print('cast lightning_shield: ', target_position)
	var target_cell = Matrix.get_cell(target_position)
	var target_unit = target_cell.unit
	if target_unit != null:
		target_unit.change_status("lightning_shield")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass