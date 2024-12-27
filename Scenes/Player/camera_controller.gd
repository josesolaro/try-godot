extends Node3D

var camroot_h: float = 0
var camroot_v: float = 0

@export var cam_v_max: int = 75
@export var cam_v_min: int = -55

var h_sensitivity: float = 0.01
var v_sensitivity: float = 0.01

var h_acceleration: float = 10.0
var v_acceleration: float = 10.0


func _input(event: InputEvent)->void:
	if event is InputEventMouseMotion and Input.is_action_pressed("move_cam"): 
		camroot_h += -event.relative.x * h_sensitivity
		camroot_v += event.relative.y * v_sensitivity

func _physics_process(delta: float) -> void:
	camroot_v = clamp(camroot_v, deg_to_rad(cam_v_min), deg_to_rad(cam_v_max))
	
	$h.rotation.y = lerpf($h.rotation.y, camroot_h, delta*h_acceleration)
	$h/v.rotation.x = lerpf($h/v.rotation.x, camroot_v, delta*v_acceleration)
