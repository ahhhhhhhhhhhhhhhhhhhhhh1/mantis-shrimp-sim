extends Label


func _on_ready() -> void:
	pass

func _physics_process(_delta):
	text = "Sand Dollar " + str(global.sand_dollar)
