extends Control

# Pega a referência do seu botão
@onready var botao_voltar: TextureButton = $MarginContainer/OptionsBtns/BtnBack

func _ready() -> void:
	# Foca no botão automaticamente (ótimo para quem joga só no teclado/setinhas)
	botao_voltar.grab_focus()
	
	# Conecta o clique do botão via código para evitar erros no editor
	if not botao_voltar.pressed.is_connected(_ao_clicar_em_voltar):
		botao_voltar.pressed.connect(_ao_clicar_em_voltar)

func _ao_clicar_em_voltar() -> void:
	# Reseta o progresso da história para o jogador poder jogar de novo do zero
	GameManager.fase_da_historia = 0
	
	# Muda a cena de volta para o menu principal. 
	# ATENÇÃO: Troque o caminho abaixo para o nome exato da sua cena de Menu!
	get_tree().change_scene_to_file("res://ui/menu/main.tscn")
