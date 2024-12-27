extends Control

@onready var health_num_label = $health_num


func _on_player_player_stats_updated(data: Dictionary) -> void:
	$health_num.text = str(data["health"])
