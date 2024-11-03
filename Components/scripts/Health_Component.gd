extends Node

signal health_changed(new_health)

@export var max_health: int = 100
var current_health: int = max_health

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int) -> void:
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	emit_signal("health_changed", current_health)

func heal(amount: int) -> void:
	current_health += amount
	current_health = clamp(current_health, 0, max_health)
	emit_signal("health_changed", current_health)
