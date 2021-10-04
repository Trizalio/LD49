extends Spell


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func cast(target_position: Vector2):
	print('cast firejet: ', target_position)
#	for 
	var line_x = target_position.x
	print( "line for jet ", line_x )
	for cell_y in range(Matrix.matrix_height -1, -1, -1):
		
		var target_cell = Matrix.get_cell(Vector2(line_x, cell_y))
		var target_unit = target_cell.unit
		if target_unit != null:
			target_unit.change_status("firejet", "burning")
#	$FireballSpell.play()
