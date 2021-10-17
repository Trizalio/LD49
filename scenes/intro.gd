extends MarginContainer

var sound = preload("res://resources/sounds/8bit-background-intro-music (mp3cut.net).mp3")

func _ready():
	AudioManager.play_this(sound)

func _on_continue_pressed():
	SceneChanger.goto_scene('res://scenes/game.tscn', 0.5, 0.5)
