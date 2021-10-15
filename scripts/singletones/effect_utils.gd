extends Node



var _LightningDamage = preload("res://effects/lightning_damage.tscn")
var _FireDamage = preload("res://effects/fire_damage.tscn")

func LightningDamage():
	return _LightningDamage.instance()

func FireDamage():
	return _FireDamage.instance()

