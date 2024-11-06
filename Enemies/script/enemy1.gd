extends CharacterBody2D

@export var move_speed: float = 50.0  # Velocidade de movimento do inimigo
@onready var _animation_tree = $AnimationTreeEnemy  # Referência ao AnimationTree do inimigo
@onready var _state_machine = _animation_tree.get("parameters/playback")  # Referência ao StateMachine dentro do AnimationTree

var player = null  # Referência ao jogador (príncipe)

func _ready() -> void:
	# Encontrar o jogador (princeScene) diretamente na cena menuStartMap
	player = get_parent().get_node_or_null("princeScene")
	
	if player == null:
		print("Erro: Não foi possível encontrar o jogador na cena.")
	else:
		print("Jogador encontrado na posição: ", player.position)

func _physics_process(delta: float) -> void:
	if player != null:
		# Calcula a direção para o jogador
		var direction = (player.global_position - global_position).normalized()
		
		# Atualiza a velocidade para que o inimigo se mova na direção do jogador
		velocity = direction * move_speed
		move_and_slide()

		# Atualiza a animação do inimigo com base no movimento
		if velocity.length() > 0:
			# Inicia a animação de walk (se estiver se movendo)
			_state_machine.travel("walk")
			# Define a direção do movimento (verifica para qual lado o inimigo está indo)
			if direction.x > 0:
				_animation_tree.set("parameters/idle/blend_position", Vector2(1, 0))  # Idle right
				_animation_tree.set("parameters/walk/blend_position", Vector2(1, 0))  # Walk right
			else:
				_animation_tree.set("parameters/idle/blend_position", Vector2(-1, 0))  # Idle left
				_animation_tree.set("parameters/walk/blend_position", Vector2(-1, 0))  # Walk left
		else:
			# Se o inimigo não estiver se movendo, ele entra no estado idle
			_state_machine.travel("idle")
