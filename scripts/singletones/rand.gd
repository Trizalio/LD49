extends Node

var rand = RandomNumberGenerator.new()

func _ready():
	rand.randomize()

func randf_range(from: float, to: float):
	return rand.randf_range(from, to)
	
