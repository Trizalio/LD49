extends Node

enum Types {Physical, Fire, Ice, Lightning}

class Damage:
	var attacker = null
#	var is_melee: bool = true
	var type
	var delay: bool = true
	
	func _init(type_, attacker_):
		attacker = attacker_
		type = type_

func damage(type_: int, attacker_):
	return Damage.new(type_, attacker_)
