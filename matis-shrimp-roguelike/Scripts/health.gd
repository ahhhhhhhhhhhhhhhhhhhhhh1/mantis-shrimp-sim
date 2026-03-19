extends Label

func _physics_process(_delta):
	text = "HEALTH " + str(global.player_health)
