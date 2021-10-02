extends TextureRect
class_name Unit

var coordinates = null

func move():
	print("Move")

func move_straight():
	var coordinates =  Matrix.get_unit_coordinates(self)
	var neighbors  = Matrix.get_neighbors(coordinates[0], coordinates[1])
	if not neighbors.bottom_neighbor:
		Matrix.move_to(coordinates[0], coordinates[1],
		 coordinates[0] + 1, coordinates[1])
	print("move_straight")
