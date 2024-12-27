class_name Damageable extends Node

signal damaged(value: float, time: float)

func damage(value: float, time: float = 0) -> void:
	emit_signal("damaged", value, time)
	
