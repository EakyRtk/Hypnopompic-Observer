extends Node2D

#INFO: enemies move towards the center gradually and evade from player bullets

static var max_evasion := 2

@onready var enemy_sprite = $EnemySprite

@export var bullet_size := 3
@export var speed := 90
@export var rmove_range := 120

#INFO: If black enemy summons under invert area it will result an invisible enemy.
@export_enum("White/Inverted", "Black") var color_type := 0

var evasion := 0
var can_move := true


func _ready():

	if color_type == 1:
		modulate = Color.BLACK
		
	await get_tree().create_timer(2).timeout
	_do_sequence()

func _process(delta):
	_move(delta)

#TODO: enemies will follow same sequence and fire a timer signal to redo it again
func _do_sequence():
	can_move = false
	_random_move()
	#TODO:shoot
	await get_tree().create_timer(2).timeout
	can_move = true
	await get_tree().create_timer(2).timeout
	#TODO:shoot
	can_move = false

func _move(delta):
	if not can_move:
		return
	position += position.direction_to(Vector2(960, 540)) * delta * speed
	
func _random_move():
	var random_move_tween = create_tween()
	random_move_tween.tween_property(self, "position",
	 position + Vector2(randi_range(-rmove_range, rmove_range), randi_range(-rmove_range, rmove_range)), 2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

func evade():
	#TODO: implement
	pass

func hurt():
	#TODO: add stuff before enemy dies
	enemy_sprite.hide()
	queue_free()
	#print("enemy hurt")
