extends Node2D

@onready var menu_start_map = preload("res://Maps/scenes/menuStartMap.tscn").instantiate()  # Carrega e instancia o menuStartMap
@onready var prince = preload("res://Characters/scenes/princeScene.tscn").instantiate()  # Carrega e instancia o príncipe
@onready var enemy1 = preload("res://Enemies/scenes/enemy1.tscn").instantiate()  # Carrega e instancia o inimigo

func _ready() -> void:
	# Adiciona o menuMap à cena principal
	add_child(menu_start_map)

	# Adiciona o príncipe à cena principal
	add_child(prince)

	# Adiciona o inimigo à cena principal
	add_child(enemy1)

	# Ajusta z_index para garantir que o príncipe e o inimigo estejam visíveis
	menu_start_map.z_index = 1  # menuMap é desenhado atrás do príncipe e do inimigo
	prince.z_index = 2    # príncipe é desenhado na frente do menuMap
	enemy1.z_index = 3    # inimigo é desenhado à frente do príncipe

	# Posiciona o príncipe e o inimigo na cena
	prince.position = Vector2(100, 100)  # Ajuste a posição conforme necessário
	enemy1.position = Vector2(300, 100)  # Ajuste a posição conforme necessário

	# Passa a referência do príncipe para o inimigo
	enemy1.set("player", prince)  # Definindo uma variável no inimigo para o jogador

	# Imprima a posição para verificar se tudo está correto
	print("Príncipe posicionado em: ", prince.position)
	print("Inimigo posicionado em: ", enemy1.position)
