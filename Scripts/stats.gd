extends Node

signal health_updated(value: float)

var health = 100

func _on_damageable_damaged(value: float, time: float) -> void:
	health -= value
	emit_signal("health_updated", health)
	print(health)
