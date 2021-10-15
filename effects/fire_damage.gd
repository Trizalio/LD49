extends Node2D

func _ready():
	$sprite.play()

func _on_sprite_animation_finished():
	get_parent().remove_child(self)
