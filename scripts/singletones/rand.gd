extends Node

var rand = RandomNumberGenerator.new()

func _ready():
	rand.randomize()

func randf_range(from: float, to: float):
	return rand.randf_range(from, to)
	
func check(chance: float) -> bool:
	return chance >= randf_range(0, 1)
