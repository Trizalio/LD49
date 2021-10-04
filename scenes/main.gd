extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_start_pressed():
	SceneChanger.goto_scene('res://scenes/intro.tscn', 0.5, 0.5)



func _on_Exit_pressed():
	get_tree().quit() # Replace with function body.
