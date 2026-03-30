extends CharacterBody3D

const hp = 50
const dmg = 10
const coins = 5
const min_atk = 5 # should be <= the max distance to be able to atck from 
var speed

func _ready() -> void:
	speed = global.player.speed * 0.4

func _process(delta: float) -> void:
	look_at(global.player_pos)
	
	if global_position.distance_to(global.player_pos) <= min_atk:
		if global_position.distance_to(global.player_pos) < min_atk:
			velocity = transform.basis.z
	else:
		velocity = -transform.basis.z
	
	
	move_and_slide()
