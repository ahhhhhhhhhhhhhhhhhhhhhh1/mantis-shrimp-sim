extends CharacterBody3D

var hp
var dmg
var coins
const min_atk = 5 # should be <= the max distance to be able to atck from 
const threashhold = 2
var speed
@onready var nav = $NavigationAgent3D

#50 10 5
func _ready() -> void:
	speed = global.player.speed * 0.4
	hp = 50 * global.difficulty
	dmg = 10 * global.difficulty
	coins = 5 * global.difficulty
	
func _process(delta: float) -> void:
	look_at(global.player_pos)
	nav.set_target_position(global.player_pos)
	
	var next_pos = nav.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	velocity = direction * speed
	
	if abs(global_position.distance_to(global.player_pos) - min_atk) > threashhold:
		if global_position.distance_to(global.player_pos) < min_atk:
			velocity = -transform.basis.z
		else:
			pass
	
	
	move_and_slide()
