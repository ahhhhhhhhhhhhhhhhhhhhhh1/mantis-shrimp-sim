extends Camera3D
@export var no : Node
@export var player : Node
var diddy = 0
var toggle = false
var mat
var paused_position = 0

func _ready() -> void:
	mat = no.material
	# Load your audio file from disk
	var audio = load("res://clam flashbang/blue disco.ogg")
	
	audio.loop = true  # enable looping

# Assign it to the AudioStreamPlayer
	player.stream = audio
	player.play()
	

func _process(delta: float) -> void:
	if global._flash == 1:
		global._flash = 0
		no.show()
		diddy += 5.1 # makes 5 seconds before its 1.1s
		if player.playing:
			paused_position = player.get_playback_position()
		player.play()
		player.play(paused_position)
	
	if diddy != 0:
		mat.set_shader_parameter("a", (diddy))
		diddy = diddy * 0.995
	
	if diddy < 0.1:
		no.hide()
		mat.set_shader_parameter("a", 0)
		if player.playing:
			paused_position = player.get_playback_position()
		player.stop()
		diddy = 0
	else:
		player.volume_db = clamp((-50 + (diddy * 50)), -50, 0) 
		
