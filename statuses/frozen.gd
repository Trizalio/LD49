extends Status

var hint_ = (
	"Deals damage at unit`s turn end; " +
	"deals damage if changed with more burning status;" + 
	"cancels frozen status"
)
onready var sprite = $sprite

var lifespan: int = 0
func _init().("Frozen", hint_):
	lifespan = 2

func animate_applied(__):
	print('animate_applied')
	sprite.play()
	pass

func on_turn_start() -> bool:
	lifespan -= 1
	emit_animate(self, "melt", lifespan)
	if lifespan == 0:
		vanish()
	return false


func on_changed(new_status: Status) -> bool:
	if new_status._name == StatusUtils.Burning()._name:
		vanish()
		return false
	if new_status._name == self._name:
		var target_position = Matrix.get_unit_coordinates(_owner)
		_owner.die()
		Matrix.enter_matrix(target_position, UnitsGenerator.FrostShardUnit.instance())
	return true

func animate_melt(life: int):
	var target = self
	if life:
		target = sprite
		
	$bg_sprite.visible = true
	var duration: float = GameState.get_rand_animation_duration()		
#	Animator.animate(target, "scale", Vector2(0, 0), duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	Animator.animate(target, "modulate", Color(1, 1, 1, 0), duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, life==0)
#	Animator.animate(target, "position", Vector2(0, 25), duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)

func animate_on_changed(__):
	pass
