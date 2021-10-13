extends MarginContainer

func _ready():
	pass

func _on_start_pressed():
	SceneChanger.goto_scene('res://scenes/intro.tscn', 0.5, 0.5)

func _on_Exit_pressed():
	get_tree().quit()

