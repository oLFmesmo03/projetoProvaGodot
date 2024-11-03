extends Node2D

@onready var menu_map = preload("res://Maps/scenes/menuMap.tscn").instantiate()  # Carrega e instancia o menuMap
@onready var prince = preload("res://Characters/scenes/princeScene.tscn").instantiate()  # Carrega e instancia o príncipe

func _ready() -> void:
	# Adiciona o menuMap à cena principal
	add_child(menu_map)

	# Adiciona o príncipe à cena principal
	add_child(prince)

	# Ajusta z_index para garantir que o príncipe esteja na frente do menuMap
	menu_map.z_index = 1  # menuMap é desenhado atrás do príncipe
	prince.z_index = 2    # príncipe é desenhado na frente

	# Posiciona o príncipe na cena (opcional)
	prince.position = Vector2(100, 100)  # Ajuste a posição conforme necessário

func _process(delta: float) -> void:
	# Adicione qualquer lógica de atualização contínua aqui, se necessário
	pass
