extends CharacterBody3D

@export var cam : Node
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var dash_vel = 2.5
@export var gravity = -2.5
@export var friction = 10

var mouse_sensitivity := 0.002
var rotation_x := 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	global.player_obj = self

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_x -= event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, deg_to_rad(-89), deg_to_rad(89))
		rotation.y -= event.relative.x * mouse_sensitivity
		cam.rotation.x = rotation_x

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	if Input.is_action_just_pressed("Sprint"):
		velocity += get_camera_direction_vector(cam, dash_vel)
	
	if is_on_floor():
		velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
	
	move_and_slide()

	global.player_pos = self.global_position


	velocity *= 0.99 # water resistance

func get_camera_direction_vector(came: Camera3D, speed: float) -> Vector3:
	var forward = -came.global_transform.basis.z
	return forward.normalized() * speed
