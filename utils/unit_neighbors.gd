extends Node


class UnitNeighbors:
	pass
	var top_neighbor
	var top_right_neighbor
	var right_neighbor
	var bottom_right_neighbor
	var bottom_neighbor
	var bottom_left_neighbor
	var left_neighbor
	var top_left_neighbor


	func _init(
		_top_neighbor,
		_top_right_neighbor,
		_right_neighbor,
		_bottom_right_neighbor,
		_bottom_neighbor,
		_bottom_left_neighbor,
		_left_neighbor,
		_top_left_neighbor
	):

		top_neighbor=_top_neighbor
		top_right_neighbor = top_right_neighbor
		right_neighbor = _right_neighbor
		bottom_right_neighbor = _bottom_right_neighbor
		bottom_neighbor = _bottom_neighbor
		bottom_left_neighbor = _bottom_left_neighbor
		left_neighbor = _left_neighbor
		top_left_neighbor = _top_left_neighbor
		var list = self.get_property_list()
		for d in list:
			print("> " + d["name"])
			print("> " + str(d))
		
	func get_exist_neighbors():
		var exist_neighbors = []
		
		if top_neighbor:
			exist_neighbors.append(top_neighbor)
		
		if top_right_neighbor:
			exist_neighbors.append(top_right_neighbor)
		
		if right_neighbor:
			exist_neighbors.append(right_neighbor)
		
		if bottom_right_neighbor:
			exist_neighbors.append(bottom_right_neighbor)
		
		if bottom_neighbor:
			exist_neighbors.append(bottom_neighbor)
		
		if bottom_left_neighbor:
			exist_neighbors.append(bottom_left_neighbor)
		
		if left_neighbor:
			exist_neighbors.append(left_neighbor)
		
		if top_left_neighbor:
			exist_neighbors.append(top_left_neighbor)
		return exist_neighbors
		
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
