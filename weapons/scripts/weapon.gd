extends Area2D

# Declaração do sinal para notificar o término da animação de ataque
signal animation_finished

@onready var animation_player = $AnimationPlayerSword

func _ready() -> void:
	if animation_player:
		animation_player.animation_finished.connect(_on_animation_finished)
	else:
		print("Erro: AnimationPlayerSword não encontrado.")

# Método para iniciar a animação de ataque
func play_attack_animation() -> void:
	if animation_player:
		animation_player.play("attack")

# Emite o sinal quando a animação de ataque termina
func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "attack":
		# Emite o sinal sem argumentos para evitar incompatibilidades
		animation_finished.emit()
