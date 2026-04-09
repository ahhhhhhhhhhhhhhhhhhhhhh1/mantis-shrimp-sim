extends RigidBody3D
var health = 120
var speed = 67
var coin_drops = 67
@onready var textlabel = $Label3D

func _physics_process(_delta):
	textlabel.text = str(health)
	if health <= 0:
		queue_free()
		global.sand_dollar += 1
		

func damagetoenemy(damage):
	health -= damage
