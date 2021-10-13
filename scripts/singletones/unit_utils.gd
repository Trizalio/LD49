extends Node

class _Race:
	var Undead = "Undead"
	var Greenskin = "Greenskin"
	var Demon = "Demon"
	var Special = "Special"

var Race := _Race.new()

func _ready():
	print(Race.Demon)
