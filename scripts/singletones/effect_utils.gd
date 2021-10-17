extends Node



var _LightningDamage = preload("res://effects/lightning_damage.tscn")
var _FireDamage = preload("res://effects/fire_damage.tscn")
var _SteamCloud = preload("res://effects/steam_cloud.tscn")
var _BlackCloud = preload("res://effects/black_cloud.tscn")
var _GreenCloud = preload("res://effects/green_cloud.tscn")

func LightningDamage():
	return _LightningDamage.instance()

func FireDamage():
	return _FireDamage.instance()

func SteamCloud():
	return _SteamCloud.instance()

func BlackCloud():
	return _BlackCloud.instance()

func GreenCloud():
	return _GreenCloud.instance()

