extends Button


func _on_button_up() -> void:
	GameManager.current_day = GameManager.current_day + 1
	print(GameManager.current_day)
	
	get_tree().reload_current_scene()
