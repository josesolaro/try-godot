extends MonsterState

func enter(previous_state_path: String, data := {}) ->void:
	monster.animation_player.play("Idle")
