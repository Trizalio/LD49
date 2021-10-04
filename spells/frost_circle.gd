extends Spell

var hint = ('Spell: frost circle \nProperties: kills units in a circle from the selected tile')
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func cast(target_position: Vector2):
	print('cast frost_circle: ', target_position)
#	var target_cell = Matrix.get_cell(target_position)
#	var target_unit = target_cell.unit
	var neighbors = Matrix.get_neighbors(target_position)
	var exist_neighbors = neighbors.get_exist_neighbors()
	print(str(exist_neighbors))
	for neighbor in exist_neighbors:
		if neighbor != null:
			neighbor.change_status("frost_circle", "frozen")
#			Matrix.interact_with_unit(self, neighbor, "take_damage")
#	$FireballSpell.play()
