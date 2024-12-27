extends CharacterBody3D

@export var gravity: float = 9.8
@export var jump_force: float = 9
@export var walk_speed: float = 3
@export var run_speed: float = 10

signal player_stats_updated(data: Dictionary)

var idle_node_name: String = "Idle"
var walk_node_name: String = "Walk"
var run_node_name: String = "Run"
var jump_node_name: String = "Jump"
var attack1_node_name: String = "Attack1"
var death_node_name: String = "Death"

var is_attacking: bool = false
var is_walking: bool = false
var is_running: bool = false
var is_dying: bool = false
var is_jumping: bool = false

var horizontal_velocity: Vector3
var vertical_velocity: Vector3
var aim_turn: float
var movement: Vector3
var movement_speed: float = 3
var angular_acceleration: float = 1.3
var acceleration: float = 2
var just_hit: bool

@onready var camroot_h = $camroot/h
@onready var knight = $Knight
@onready var animation_tree = $AnimationTree

func _ready() -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		aim_turn = -event.relative.x * 0.015
	
func _physics_process(delta: float) -> void:
	var direction: Vector3 = Vector3.ZERO
	if is_dying:
		pass
	
	if Input.is_action_pressed("attack") and !is_attacking:
		is_attacking = true
	else:
		is_attacking = false
		
	var on_floor = 	is_on_floor()
	if !on_floor:
		vertical_velocity += Vector3.DOWN * gravity * 2 * delta
	else:
		is_jumping = false
		
	if Input.is_action_just_pressed("jump") and !is_jumping and !is_attacking:
		vertical_velocity = Vector3.UP * jump_force
		is_jumping = true
		
	
	if(Input.is_action_pressed("forward") or Input.is_action_pressed("backward")
		or Input.is_action_pressed("left") or Input.is_action_pressed("right")):
			direction = Vector3(
				Input.get_action_strength("left") - Input.get_action_strength("right"),
				0,
				Input.get_action_strength("forward") - Input.get_action_strength("backward")
			)
			if Input.is_action_pressed("sprint") and is_walking:
				movement_speed = run_speed
				is_running = true
			else:
				movement_speed = walk_speed
				is_walking = true
				is_running = false
	else:
		is_walking = false
		is_running = false		
			
	if Input.is_action_pressed("aim"):
		rotation.y = lerp(rotation.y, camroot_h.global_transform.basis.get_euler().y, delta * angular_acceleration)
		
	knight.rotation.y = camroot_h.rotation.y
	direction = direction.rotated(Vector3.UP, camroot_h.rotation.y)
		
	if is_attacking:
		horizontal_velocity = horizontal_velocity.lerp(direction * 0.1, acceleration)
	else:
		horizontal_velocity = horizontal_velocity.lerp(direction * movement_speed, acceleration)
		
	velocity.z = horizontal_velocity.z 
	velocity.x = horizontal_velocity.x
	velocity.y = vertical_velocity.y

	move_and_slide()
	play_animation()
	
func play_animation():
	animation_tree["parameters/conditions/IsAttacking"] = is_attacking
	if !is_attacking:
		animation_tree["parameters/conditions/IsWalking"] = is_walking
		animation_tree["parameters/conditions/IsNotWalking"] = !is_walking
		animation_tree["parameters/conditions/IsRunning"] = is_running
		animation_tree["parameters/conditions/IsNotRunning"] = !is_running
		animation_tree["parameters/conditions/IsJumping"] = is_jumping


func _on_sword_area_body_entered(body: Node3D) -> void:
	if is_attacking:
		if body.has_node("Damageable"):
			var target = body.get_node("Damageable") as Damageable
			target.damage(10)


func _on_stats_health_updated(value: float) -> void:
	emit_signal("player_stats_updated", {"health": value})
