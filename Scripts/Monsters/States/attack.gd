extends MonsterState

func enter(previous_state_path: String, data := {}) ->void:
	monster.animation_player.play("1H_Melee_Attack_Chop")
	var target = data["target"] as Node3D
	if target.has_node("Damageable"):
		var target_damagable = target.get_node("Damageable") as Damageable
		target_damagable.damage(10)
