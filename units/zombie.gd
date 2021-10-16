extends Unit

#var _race = "undead"

var hint = ("On blocked: wanders around") 

var enraged = false

func _init().("undead", 1, "zombie", hint):
	pass

func _act():
	wander_move()
	return
#	print( "zooooooobie acting")
#	var coordinates = Matrix.get_unit_coordinates(self)
#	var neighbors = Matrix.get_neighbors(coordinates)
#	var exist_neighbors = neighbors.get_exist_neighbors()
##	if neighbors.right_neighbor:
##		if neighbors.right_neighbor.get_race() != self._race:
###			interact_to_unit(self, neighbors.right_neighbor, "take_damage")
###			interact_to_unit(self, neighbors.right_neighbor, "take_damage")
##			if neighbors.right_neighbor.get_status() != "frozen":
##				neighbors.right_neighbor.change_status(self, "frozen")
##				emit_signal("interact", self, neighbors.left_neighbor, "change_status", "frozen")
##				return
#	if inraged:
#		var traget = neighbors.bottom_neighbor
#		if traget:
#			interact_to_unit(self, traget, "take_damage")
#			inraged = false
#			return
#
#	var mooved = wander_move()
#	if !mooved:
#		inraged = true
##	_move_crazy(coordinates, neighbors)
##	self.change_status(self, "frozen")


#
#func _move_crazy(coordinates, neighbors):
#	var straight_empty_cells = []
#	var other_empty_cells = []
#	if not neighbors.top_right_neighbor:
#		var target_coord = (coordinates + Vector2(1, -1))
#		if Matrix.is_in_matix(target_coord):
#			other_empty_cells.append(target_coord)
#
#	if not neighbors.right_neighbor:
#		var target_coord = (coordinates +  Vector2(1, 0))
#		if Matrix.is_in_matix(target_coord):
#			other_empty_cells.append(target_coord)
##
#	if not neighbors.bottom_right_neighbor:
#
#		var target_coord = (coordinates +  Vector2(1, -1))
#		if Matrix.is_in_matix(target_coord):
#			straight_empty_cells.append(target_coord)
##
#	if not neighbors.bottom_neighbor:
#
#		var target_coord = (coordinates +  Vector2(0, 1))
#		if Matrix.is_in_matix(target_coord):
#			straight_empty_cells.append(target_coord)
##
#	if not neighbors.bottom_left_neighbor:
#
#		var target_coord = (coordinates +  Vector2(-1, 1))
#		if Matrix.is_in_matix(target_coord):
#			straight_empty_cells.append(target_coord)
##
#	if not neighbors.left_neighbor:
#
#		var target_coord = (coordinates +  Vector2(-1, 0))
#		if Matrix.is_in_matix(target_coord):
#			other_empty_cells.append(target_coord)
##
#	if not neighbors.top_left_neighbor:
#		var target_coord = (coordinates +  Vector2(-1, -1))
#		if Matrix.is_in_matix(target_coord):
#			other_empty_cells.append(target_coord)	
##	
#	var move_to = null
#	print("move_to " + str(move_to))
#	if straight_empty_cells:
#		move_to = straight_empty_cells[randi() % straight_empty_cells.size()]
#	elif other_empty_cells:
#		move_to = other_empty_cells[randi() % other_empty_cells.size()]
#
#	if move_to:
#		if Matrix.get_cell(move_to).unit == null:
#			Matrix.move_unit(coordinates, move_to)
##
#
#
#	pass
