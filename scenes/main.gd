extends MarginContainer

func _ready():
	AudioManager.play_this($background.stream, $background.volume_db)

func _on_start_pressed():
	SceneChanger.goto_scene('res://scenes/intro.tscn', 0.5, 0.5)
