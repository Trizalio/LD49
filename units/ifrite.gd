extends Unit

var hint = ('Unit: efreet \nRace: daemons \nMove: move to one of 3 tiles'+
'ahead\n Properties: if no way - charge itself, burn all neighboors at the next turn')

var enraged = false

func _ready():
	self._race =  "demon"
	self._tier =  3
#	change_status(self ,"lightning_shield")

func get_race():
	return "demon"

func get_tier():
	return 3
func _act():
	var moved = nimble_move()
	if moved:
		return
	else:
		if not enraged: 
			enraged = true
			return
		else: 
			var coordinates = Matrix.get_unit_coordinates(self)
			var neighbors = Matrix.get_neighbors(coordinates)
			var exist_neighbors = neighbors.get_exist_neighbors()
			for traget in exist_neighbors:
				if traget:
					if traget.get_race() != self._race:
						traget.change_status(null, "burning")
				
#	move_straight()
	
	
#func _move_smart(coordinates, neighbors):
#	if Matrix.is_next_to_town(coordinates):
#		Matrix.exit_from(coordinates)
#		return
#
#	var straight_empty_cells = []
#
#	if not neighbors.bottom_right_neighbor:
#
#		var target_coord = (coordinates +  Vector2(1, -1))
#		if Matrix.is_in_matix(target_coord):
#			print(Matrix.is_in_matix(target_coord), target_coord)
#			straight_empty_cells.append(target_coord)
#	#
#	if not neighbors.bottom_neighbor:
#
#		var target_coord = (coordinates +  Vector2(0, 1))
#		if Matrix.is_in_matix(target_coord):
#			print(Matrix.is_in_matix(target_coord), target_coord)
#			straight_empty_cells.append(target_coord)
#	#
#	if not neighbors.bottom_left_neighbor:
#
#		var target_coord = (coordinates +  Vector2(-1, 1))
#		if Matrix.is_in_matix(target_coord):
#			print(Matrix.is_in_matix(target_coord), target_coord)
#			straight_empty_cells.append(target_coord)
#	#
#	#	
#	var move_to = null
#
#	if straight_empty_cells:
#		move_to = straight_empty_cells[randi() % straight_empty_cells.size()]
#
#
#		print("move_to " + str(move_to))
#		if Matrix.get_cell(move_to).unit == null:
#			Matrix.move_unit(coordinates, move_to)
#
