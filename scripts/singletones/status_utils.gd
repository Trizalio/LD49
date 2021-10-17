extends Node


var _Burning = preload("res://statuses/burning.tscn")
var _Frozen = preload("res://statuses/frozen.tscn")
var _Stunned = preload("res://statuses/stunned.tscn")

func Burning():
	return _Burning.instance()
	
func Frozen():
	return _Frozen.instance()
	
func Stunned():
	return _Stunned.instance()
