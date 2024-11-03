extends CharacterBody2D

@export_category("Variables")
@export var _move_speed: float = 64.0
@export var _friction: float = 0.2
@export var _acceleration: float = 0.2

@onready var _animation_tree = $AnimationTree
@onready var _state_machine = _animation_tree["parameters/playback"]

@onready var sword_area = preload("res://weapons/scenes/basicSword.tscn").instantiate()
@onready var sword_animation_player = null

@onready var health_label = $HealthLabel  # Referência ao Label que exibe a vida

var health_component = preload("res://Components/scripts/Health_Component.gd").new()  # Carregando o componente de vida

var is_attacking = false
var current_animation = ""  # Armazena a animação atual

# Variáveis para armazenar a posição e rotação da espada durante o ataque
var attack_position: Vector2 = Vector2.ZERO
var attack_rotation: float = 0.0

func _ready() -> void:
	# Adiciona a espada como filha
	add_child(sword_area)
	sword_area.position = Vector2(0, -10)  # Ajuste a posição inicial no eixo Y
	sword_area.visible = true  # A espada permanece visível o tempo todo

	# Corrige o caminho para o AnimationPlayer da espada
	sword_animation_player = sword_area.get_node("AnimationPlayerSword")
	if sword_animation_player:
		sword_animation_player.animation_finished.connect(self._on_attack_finished)
	else:
		print("Erro: AnimationPlayerSword não encontrado em basicSword.")

	# Adiciona o componente de vida ao personagem e conecta o sinal de mudança de vida
	add_child(health_component)
	health_component.health_changed.connect(self._on_health_changed)  # Conecta o sinal corretamente

	# Inicializa a label de vida com a vida máxima
	health_label.text = str(health_component.max_health)  # Exibe a vida máxima

func _input(event) -> void:
	if event.is_action_pressed("attack") and not is_attacking:
		attack()

func _physics_process(_delta: float) -> void:
	_move()
	_animate()
	move_and_slide()

	# Atualiza a posição e rotação da espada com base na posição do mouse
	update_sword_position()

func _move() -> void:
	var _direction: Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	if _direction != Vector2.ZERO:
		_animation_tree["parameters/idle/blend_position"] = _direction
		_animation_tree["parameters/walk/blend_position"] = _direction

		velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _acceleration)
		velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _acceleration)

		return

	velocity.x = lerp(velocity.x, 0.0, _friction)
	velocity.y = lerp(velocity.y, 0.0, _friction)

func _animate() -> void:
	# Prioriza a animação de ataque
	if is_attacking:
		if current_animation != "attack":
			current_animation = "attack"  # Atualiza para a animação de ataque
			if sword_animation_player:
				sword_animation_player.play("attack")  # Toca animação de ataque da espada
		return  # Não faz nada mais aqui enquanto ataca

	# Alterna entre "walk" e "idle" apenas se não estiver atacando
	if velocity.length() > 10:
		if current_animation != "walk":
			_state_machine.travel("walk")
			current_animation = "walk"
	else:
		if current_animation != "idle":
			_state_machine.travel("idle")
			current_animation = "idle"
			if sword_animation_player:
				sword_animation_player.play("idle")  # Toca animação idle da espada

func attack() -> void:
	if is_attacking:
		return  # Impede múltiplos ataques simultâneos

	is_attacking = true
	current_animation = "attack"  # Atualiza para animação de ataque

	# Guarda a posição e rotação da espada no início do ataque
	var mouse_position = get_global_mouse_position()
	var direction_to_mouse = (mouse_position - global_position).normalized()
	var distance_horizontal = 8
	var distance_vertical_offset = -4  # Ajuste conforme necessário para alterar o eixo Y
	attack_position = Vector2(
		direction_to_mouse.x * distance_horizontal,
		direction_to_mouse.y * distance_horizontal + distance_vertical_offset
	)
	attack_rotation = direction_to_mouse.angle()

	# Inicia a animação de ataque da espada
	if sword_animation_player:
		sword_animation_player.play("attack")
	else:
		print("Erro: AnimationPlayer da espada não encontrado.")

func _on_attack_finished(_animation_name: String) -> void:
	is_attacking = false
	current_animation = ""

	# A espada deve voltar para a animação idle
	if sword_animation_player:
		sword_animation_player.play("idle")  # Toca animação idle da espada

	# Verifica se o personagem está se movendo ou não
	if velocity.length() > 0:
		_state_machine.travel("walk")  # Volta para o estado de andar se o personagem estiver se movendo
	else:
		_state_machine.travel("idle")  # Volta para o estado de inatividade se não estiver se movendo

# Função para atualizar a posição e rotação da espada com base na posição do mouse
func update_sword_position() -> void:
	if is_attacking:
		# Enquanto estiver atacando, fixa a posição e rotação inicial do ataque
		sword_area.position = attack_position
		sword_area.rotation = attack_rotation
	else:
		var mouse_position = get_global_mouse_position()
		var direction_to_mouse = (mouse_position - global_position).normalized()

		# Definindo uma distância horizontal e vertical ajustáveis
		var distance_horizontal = 8
		var distance_vertical_offset = -4  # Ajuste conforme necessário para alterar o eixo Y

		# Define a posição da espada com deslocamento no eixo Y
		sword_area.position = Vector2(
			direction_to_mouse.x * distance_horizontal,
			direction_to_mouse.y * distance_horizontal + distance_vertical_offset
		)
		sword_area.rotation = direction_to_mouse.angle()  # Alinha a rotação da espada à direção do mouse

		# Inverte a espada no eixo Y se o mouse estiver do lado esquerdo do personagem
		if mouse_position.x < global_position.x:
			sword_area.scale.y = -1  # Espelha verticalmente
		else:
			sword_area.scale.y = 1  # Normaliza para o lado direito

# Recebe a mudança de vida e lida com a morte do personagem
func _on_health_changed(new_health: int) -> void:
	print("Vida do personagem alterada:", new_health)
	health_label.text = str(new_health)  # Atualiza o texto do Label com a nova vida
	if new_health <= 0:
		die()

# Função para lidar com a morte do personagem
func die() -> void:
	queue_free()  # Ou qualquer lógica adicional ao morrer
