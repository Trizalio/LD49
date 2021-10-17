extends MarginContainer

var sound = preload("res://resources/sounds/intro (mp3cut.net).mp3")

func _ready():
	AudioManager.play_this(sound, 0)
#	AudioManager.fade_in()
	pass

func _on_start_pressed():
	SceneChanger.goto_scene('res://scenes/intro.tscn', 0.5, 0.5)
