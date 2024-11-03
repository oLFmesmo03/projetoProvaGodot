extends Area2D

signal hit(damage: int)

@export var damage: int = 10  # Dano padrão do hitbox

func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")

func _on_area_entered(area: Area2D) -> void:
	emit_signal("hit", damage)  # Emite o dano para que o objeto que recebeu possa reagir
