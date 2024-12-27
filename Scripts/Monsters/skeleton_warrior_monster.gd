class_name SkeletonWarriorMonster extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var animation_player: AnimationPlayer
var state_machine: StateMachine

func _ready() -> void:
	animation_player = $Skeleton_Warrior/AnimationPlayer
	state_machine = $StateMachine
	await state_machine.ready
	state_machine._transition_to_next_state("Idle")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

func _on_attack_target_body_entered(body: Node3D) -> void:
	state_machine._transition_to_next_state("Attack", {"target":body})

func _on_attack_target_body_exited(body: Node3D) -> void:
	state_machine._transition_to_next_state("Idle")

func _on_stats_health_updated(value: float) -> void:
	$Label3D.text = str(value)
