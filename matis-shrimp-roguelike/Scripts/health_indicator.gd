extends Polygon2D


func _physics_process(delta):
	scale.x = global.player_health * 3
