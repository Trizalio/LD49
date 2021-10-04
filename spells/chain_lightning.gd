extends Spell


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var chain_lighting_counter = 0
var max_counter = 3
var _target_race = null
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func cast(target_position: Vector2):
	print('cast chain lighting: ', target_position)
#	var target_cell = Matrix.get_cell(target_position)
#	var target_unit = target_cell.unit
	var target_cell = Matrix.get_cell(target_position)
	var target_unit = target_cell.unit
	if target_unit != null:
		_target_race = target_unit.get_race()
		_apply_chain_lighting(target_unit, target_position)
#		Matrix.interact_with_unit(self, target_unit, "take_damage")

#	$FireballSpell.play()

func _apply_chain_lighting(target_unit, target_position):
	Matrix.interact_with_unit(self, target_unit, "take_damage")
	if use_again():
		var neighbors = Matrix.get_neighbors(target_position)
		var exist_neighbors = neighbors.get_exist_neighbors()
		for neighbor in exist_neighbors:
			if neighbor != null:
				if neighbor.get_race() == _target_race:
					var new_target_unit = Matrix.get_unit_coordinates(neighbor)
					_apply_chain_lighting(neighbor, new_target_unit)
					return
		return
	else:
#		chain_lighting_counter = 0
		return
		

func use_again():
	chain_lighting_counter += 1
	if chain_lighting_counter >= max_counter:
		return false
	return true
