extends Camera3D

@export var mouse_sensitivity := 0.2
@export var move_speed := 5.0
@export var sprint_multiplier := 2.0
@export var no : Node
@export var player : Node
var diddy = 0.0
var rotation_x := 0.0  # Pitch
var rotation_y := 0.0  # Yaw

var toggle = false
var mat

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mat = no.material
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_mouse_look(event)

func _mouse_look(event: InputEventMouseMotion) -> void:
	rotation_y -= event.relative.x * mouse_sensitivity
	rotation_x -= event.relative.y * mouse_sensitivity

	# Clamp vertical rotation
	rotation_x = clamp(rotation_x, -90.0, 90.0)

	rotation_degrees = Vector3(rotation_x, rotation_y, 0)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		no.show()
		diddy = 1.1
		player.play()
	
	if diddy != null:
		mat.set_shader_parameter("a", (diddy))
		diddy = diddy * 0.995
	
	if diddy < 0.1:
		no.hide()
		mat.set_shader_parameter("a", 0)
		player.stop()
	else:
		player.volume_db = (-50 + (diddy * 50))
