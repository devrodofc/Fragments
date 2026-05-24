extends Area2D

# ==========================================
# CONFIGURAÇÕES DO OBJETO DE DORMIR
# ==========================================
@export_group("Configurações da Cama")
@export var prompt_text: String = "[E] Dormir"
@export var not_done_message: String = "Ainda tenho coisas a fazer..."

@export_group("Visual do Prompt [E]")
@export var prompt_color: Color = Color.YELLOW
@export var prompt_size: int = 24
@export var prompt_offset_y: float = 60.0

@export_group("Visual da Mensagem de Recusa")
@export var text_color: Color = Color(0.8, 0.8, 0.8) # Um cinza claro
@export var font_size: int = 16
@export var text_offset_y: float = 80.0
@export var text_offset_x: float = 0.0

var player_ref: Node2D = null
var prompt_label: Label = null

# ==========================================
# INICIALIZAÇÃO
# ==========================================
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Cria a etiqueta "[E] Dormir"
	prompt_label = Label.new()
	prompt_label.text = prompt_text
	prompt_label.add_theme_color_override("font_color", prompt_color)
	prompt_label.add_theme_font_size_override("font_size", prompt_size)
	
	prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	prompt_label.grow_horizontal = Control.GROW_DIRECTION_BOTH
	
	add_child(prompt_label)
	prompt_label.position = Vector2(0, -prompt_offset_y)
	prompt_label.hide()

# ==========================================
# DETECÇÃO DO JOGADOR
# ==========================================
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_ref = body
		prompt_label.show()
		
		# Animação do prompt
		prompt_label.scale = Vector2.ZERO
		var tween = create_tween()
		tween.tween_property(prompt_label, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_SPRING)

func _on_body_exited(body: Node2D) -> void:
	if body == player_ref:
		player_ref = null
		prompt_label.hide()

# ==========================================
# AÇÃO DE INTERAÇÃO
# ==========================================
func _process(_delta: float) -> void:
	if player_ref and Input.is_action_just_pressed("interact"):
		_try_to_sleep()

func _try_to_sleep() -> void:
	# CHECAGEM PRINCIPAL: O jogador terminou a tarefa?
	if player_ref.work_done == true:
		# Se SIM, vai dormir e troca a cena!
		if GameManager.has_method("go_to_sleep"):
			GameManager.go_to_sleep()
	else:
		# Se NÃO, mostra a mensagem de recusa
		prompt_label.hide()
		_show_refusal_message()
		
		# O botão [E] reaparece depois de 1.5s se o player continuar perto
		await get_tree().create_timer(1.5).timeout
		if player_ref:
			prompt_label.show()

# ==========================================
# MENSAGEM FLUTUANTE DE RECUSA
# ==========================================
func _show_refusal_message() -> void:
	var popup_label = Label.new()
	popup_label.text = not_done_message
	
	popup_label.add_theme_color_override("font_color", text_color)
	popup_label.add_theme_font_size_override("font_size", font_size)
	
	popup_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	popup_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	popup_label.grow_horizontal = Control.GROW_DIRECTION_BOTH
	
	# A mensagem gruda no jogador
	player_ref.add_child(popup_label)
	popup_label.position = Vector2(text_offset_x, -text_offset_y)
	
	# Animação suave da mensagem
	var text_tween = popup_label.create_tween()
	text_tween.tween_property(popup_label, "position:y", popup_label.position.y - 30.0, 2.5).set_ease(Tween.EASE_OUT)
	text_tween.parallel().tween_property(popup_label, "modulate:a", 0.0, 2.5).set_ease(Tween.EASE_IN)
	text_tween.tween_callback(popup_label.queue_free)
