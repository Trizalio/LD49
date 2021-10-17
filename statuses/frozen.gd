extends Status

var hint_ = (
	"Prevents unit from actions for 2 turns; " +
	"Converts to ice shard if gets more frost"
)
onready var sprite = $sprite

var lifespan: int = 0
func _init().("Frozen", hint_):
	lifespan = 2

func _ready():
	scale = Vector2(1, 1)
	pass

func animate_applied(__):
	sprite.play()

func on_turn_start() -> bool:
	lifespan -= 1
	emit_animate(self, "melt", lifespan)
	if lifespan <= 0:
		vanish()
	return false


func on_changed(new_status: Status) -> bool:
	if new_status != null and new_status._name == StatusUtils.Burning()._name:
		lifespan -= 100
		emit_animate(self, "steam", null, false)
		emit_animate(self, "melt", lifespan)
		vanish()
		return false
	if new_status != null and new_status._name == self._name:
		var target_position = Matrix.get_unit_coordinates(_owner)
		_owner.die(false, false)
		Matrix.enter_matrix(target_position, UnitsGenerator.FrostShardUnit.instance(), true, true)
	return true

func animate_melt(life: int):
	var target = self
	if life > 0:
		target = sprite
		
	$bg_sprite.visible = true
	var duration: float = GameState.get_rand_animation_duration()		
	print('animate_melt, life:', life)
#	Animator.animate(target, "scale", Vector2(0, 0), duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	Animator.animate(target, "modulate", Color(1, 1, 1, 0), duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, life<=0)
#	Animator.animate(target, "position", Vector2(0, 25), duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)

func animate_steam(__):
	_owner.add_child(EffectUtils.SteamCloud())

func animate_on_changed(__):
	pass
