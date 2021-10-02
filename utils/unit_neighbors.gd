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
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
