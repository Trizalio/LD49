extends Node



var _LightningDamage = preload("res://effects/lightning_damage.tscn")

func LightningDamage():
	return _LightningDamage.instance()

