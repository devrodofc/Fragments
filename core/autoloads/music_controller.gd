extends AudioStreamPlayer

func _ready() -> void:
	# Assim que o jogo abrir, a música começa a tocar
	play()

# Criamos essa função para ser chamada apenas nos créditos
func reiniciar_musica() -> void:
	stop()
	play()
