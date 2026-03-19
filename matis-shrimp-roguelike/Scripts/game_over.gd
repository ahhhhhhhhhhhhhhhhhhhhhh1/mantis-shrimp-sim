extends Control


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	


func _on_ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
