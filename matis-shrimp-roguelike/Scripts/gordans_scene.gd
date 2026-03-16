extends CharacterBody3D
@export var cam : Node
const speed = 10.0
@export var gravity = 1.0
@export var jump_velocity = 1.2
@export var mouse_sensitivity = 0.003
var turn_speed = 6.0
@onready var leftarm = $LeftArm
@onready var rightarm = $RightArm
@onready var camera = $Pivot/Camera3D
@onready var lefttimer = $Leftpunchtimer
@onready var righttimer = $Rightpunchtimer
@onready var enemydetection = $EnemyDetection 
var leftpunching = false
var hashit = false
var rightpunching = false
var superpunching = false
var enemy = false
var ball_mode = false
var objects = [] 

func _ready():
	global.player_health = 100
	lefttimer.start()
	righttimer.start()
	objects = [$Legs, $Legs2, $Legs3, $Legs4, $Legs5, $Legs6, $Legs7, $Legs8, $Legs9, $Legs10]
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$Pivot.rotation.y -= event.relative.x * mouse_sensitivity
		$Pivot.rotation.x -= event.relative.y * mouse_sensitivity
		
func leftpunch():
	if lefttimer.time_left <= 0 and leftarm.position.z > -1:
		leftpunching = true
		leftarm.position.z -= 1
		await get_tree().create_timer(0.1).timeout
		leftpunching = false
		leftarm.position.z += 1
		lefttimer.start()
		hashit = false
		
func damage(dmgamout):
	if global.player_health > 0:
		global.player_health -= dmgamout
	if global.player_health <= 0:
		get_tree().change_scene_to_file("res://game_over.tscn")
func rightpunch():
	if righttimer.time_left <= 0 and rightarm.position.z > -1:
		rightpunching = true
		rightarm.position.z -= 1
		await get_tree().create_timer(0.1).timeout
		rightpunching = false
		rightarm.position.z += 1
		righttimer.start()
		hashit = false
		
func superpunch():
	if righttimer.time_left <= 0 and rightarm.position.z > -1:
		superpunching = true
		rightarm.position.z -= 2
		leftarm.position.z -= 2
		await get_tree().create_timer(0.1).timeout
		superpunching = false
		rightarm.position.z += 2
		leftarm.position.z += 2
		righttimer.start()
		hashit = false
		
func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("LeftMouse"):
		if Input.is_action_just_pressed("RightMouse"):
			superpunch()
		else:
			leftpunch()
	if Input.is_action_just_pressed("RightMouse"):
		if Input.is_action_just_pressed("LeftMouse"):
			superpunch()
		else:
			rightpunch()
	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y += jump_velocity
	if Input.is_action_pressed("Ball"):
		$BallMode.visible = true
		ball_mode = true
	else:
		ball_mode = false
		$BallMode.visible = false
	if Input.is_action_just_pressed("Sprint"):
		print("sprinting")
		velocity += get_camera_direction_vector(cam, 100)
		#This is not particuarly very good so u do better one
	move_and_slide()
	var move_dir = 0.0
	var turn_dir = 0.0
	if ball_mode == false:
		if Input.is_action_pressed("w"):
			move_dir += 1.0
		if Input.is_action_pressed("s"):
			move_dir -= 1.0
			turn_dir = 0.0
		if Input.is_action_pressed("a"):
			turn_dir += 1.0
		if Input.is_action_pressed("d"):
			turn_dir -= 1.0


	# Rotate character (left/right keys)
	rotation.y += turn_dir * turn_speed * delta

	# Move forward/back based on facing direction
	var forward = -transform.basis.z
	velocity.x = forward.x * move_dir * speed
	velocity.z = forward.z * move_dir * speed

	# Rotate legs while walking
	if move_dir != 0 or turn_dir != 0:
		for obj in objects:
			obj.rotation_degrees.y += 500 * delta

	# Smooth stop when no input
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()

	for body in $Detect.get_overlapping_bodies():
		if leftpunching or rightpunching or superpunching:
			if hashit == false:
				print(hashit)
				print(body)
				hashit = true
				if body.is_in_group("enemy"):
					
					if body != null:
						body.damagetoenemy(30)
						await get_tree().create_timer(0.3).timeout
		
func get_camera_direction_vector(came: Camera3D, speed: float) -> Vector3:
	var forward = -came.global_transform.basis.z
	return forward.normalized() * speed
	


func _on_detect_part_2_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		damage(20)
		
