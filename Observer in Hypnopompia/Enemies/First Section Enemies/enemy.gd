extends Node2D

#INFO: enemies move towards the center gradually and evade from player bullets

static var max_evasion := 2

@export var bullet_size := 3
@export var speed := 150

var evasion := 0
var can_move := true

func _ready():
	await get_tree().create_timer(0.8).timeout
	can_move = false

func _process(delta):
	_move(delta)

func _move(delta):
	if not can_move:
		return
	position += position.direction_to(Vector2(960, 540)) * delta * speed
	
func evade():
	#TODO: implement
	pass

func hurt():
	#TODO: add stuff before enemy dies
	queue_free()
	#print("enemy hurt")
