extends CharacterBody3D

@export var speed = 10.0
@export var gravity = 1.0
@export var jump_velocity = 1.2
@export var mouse_sensitivity = 0.003
@export var turn_speed = 6.0   # How fast to rotate left/right
@onready var leftarm = $LeftArm
@onready var rightarm = $RightArm
@onready var camera = $Pivot/Camera3D
@onready var lefttimer = $Leftpunchtimer
@onready var righttimer = $Rightpunchtimer
@export var ball_mode = false
var objects = [] 

func _ready():
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
		leftarm.position.z -= 1
		await get_tree().create_timer(0.3).timeout
		leftarm.position.z += 1
		lefttimer.start()
func rightpunch():
	if righttimer.time_left <= 0 and rightarm.position.z > -1:
		rightarm.position.z -= 1
		await get_tree().create_timer(0.3).timeout
		rightarm.position.z += 1
		righttimer.start()
func superpunch():
	if righttimer.time_left <= 0 and rightarm.position.z > -1:
		rightarm.position.z -= 2
		leftarm.position.z -= 2
		await get_tree().create_timer(0.3).timeout
		rightarm.position.z += 2
		leftarm.position.z += 2
		righttimer.start()

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("LeftMouse"):
		if Input.is_action_just_pressed("RightMouse"):
			superpunch()
		else:
			leftpunch()
	if Input.is_action_just_pressed("RightMouse"):
		if Input.is_action_just_pressed("RightMouse"):
			superpunch()
		else:
			rightpunch()
	# Jump
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y += jump_velocity
	if Input.is_action_pressed("Ball"):
		$BallMode.visible = true
	else:
		$BallMode.visible = false
	if Input.is_action_just_pressed("Sprint"):
		velocity += -transform.basis.z * 100
	move_and_slide()
	# Movement controls
	var move_dir = 0.0
	if Input.is_action_pressed("w"):
		move_dir += 1.0
	if Input.is_action_pressed("s"):
		move_dir -= 1.0

	var turn_dir = 0.0
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
