extends Control

@onready var botao_voltar: TextureButton = $MarginContainer/OptionsBtns/BtnBack

func _ready() -> void:
	botao_voltar.grab_focus()
	if not botao_voltar.pressed.is_connected(_ao_clicar_em_voltar):
		botao_voltar.pressed.connect(_ao_clicar_em_voltar)

func _ao_clicar_em_voltar() -> void:
	GameManager.fase_da_historia = 0
	MusicController.reiniciar_musica()
	get_tree().change_scene_to_file("res://ui/menu/main.tscn")
