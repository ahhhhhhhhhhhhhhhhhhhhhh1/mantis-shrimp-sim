extends Label3D

func _on_ready() -> void:
	await get_tree().create_timer(0.3).timeout
	var tween = create_tween()

	tween.tween_property($Label3D, "position:y", position.y + 10.5, 1.0)
	tween.tween_property($Label3D, "modulate:a", 0.0, 0.5)
	
	await tween.finished
	queue_free()
