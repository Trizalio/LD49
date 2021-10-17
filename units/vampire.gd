extends Unit

var hint = (
	'Move: move to one of 3 tiles ahead\n' +
	"Killed: becomes weak\n" +
	"Weak: freeze any enemy neighbour to recover self"
) 
var weaken: bool = false

func _init().(UnitUtils.Race.Undead, 3, "Zombie", hint):
	pass

func _act():
	if weaken:
		var target_unit = Rand.choice(
			MatrixUtils.get_units_by_shifts(
				self, MatrixUtils.all_neighbours, self.get_race()
		))
		if target_unit:
			apply_status(target_unit, Frozen.instance())
			self_animate("weak", false)
			weaken = false
			
	else:
		nimble_move()
		
func _take_damage(damage: Damage.Damage):
	if weaken:
		return ._take_damage(damage)
		
	self_animate("weak", true)
	weaken = true
	
func animate_weak(is_weak: bool):
	self.add_child(EffectUtils.BlackCloud())
	$sprite.get_material().set_shader_param("grayness", 1.0 * int(is_weak))
	$sprite.get_material().set_shader_param("fade", 0.6 * int(is_weak))
	
