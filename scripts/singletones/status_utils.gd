extends Node


var _Burning = preload("res://statuses/burning.tscn")
var _Normal = preload("res://statuses/normal.tscn")

func Burning():
	return _Burning.instance()
	
func Normal():
	return _Normal.instance()
