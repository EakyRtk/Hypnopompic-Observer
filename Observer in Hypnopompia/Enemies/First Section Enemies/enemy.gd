extends Node2D

#INFO: enemies move towards the center gradually and evade from player bullets

static var max_evasion := 2

@onready var enemy_sprite = $EnemySprite
@onready var sequence_cooldown = $SequenceCooldown
@onready var breakline = $breakline


@onready var s_bullet = preload("res://Enemies/Invert Bullet/color_inverted_bullet.tscn")

@export var bullet_size := 3
@export var speed := 90
@export var rmove_range := 120

#INFO: If black enemy summons under invert area it will result an invisible enemy.
@export_enum("White/Inverted", "Black") var color_type := 0

var center := Vector2(960, 540)
var evasion := 0
var can_move := true
var no_sequence := false

func _ready():

	if color_type == 1:
		modulate = Color.BLACK
		
	await get_tree().create_timer(2).timeout
	_do_sequence()

func _process(delta):
	_move(delta)

#TODO: enemies will follow same sequence and fire a timer signal to redo it again
func _do_sequence():
	if no_sequence:
		return
	
	can_move = false
	_random_move()
	#TODO:shoot
	_shoot()
	await get_tree().create_timer(randf_range(2, 2.8)).timeout
	can_move = true
	await get_tree().create_timer(randf_range(2, 2.8)).timeout
	#TODO:shoot
	can_move = false
	sequence_cooldown.start()

func _move(delta):
	if not can_move:
		return
	position += position.direction_to(center) * delta * speed
	
func _random_move():
	var random_move_tween = create_tween()
	random_move_tween.tween_property(self, "position",
	 position + Vector2(randi_range(-rmove_range, rmove_range), randi_range(-rmove_range, rmove_range)), randf_range(0.9, 2.1)).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

func _shoot():
	for i in range(3):
		var bullet = s_bullet.instantiate()
		bullet.top_level = true
		bullet.position = position
		add_child(bullet)
		await get_tree().create_timer(randf_range(0.2, 0.6)).timeout

func do_break_effect():
	can_move = false
	no_sequence = true
	breakline.add_point(Vector2.ZERO)
	breakline.add_point(center - global_position)
	await get_tree().create_timer(randf_range(0.3, 0.5)).timeout
	var breaking_point = (center-global_position)/2
	var breaking_point2 = (center-global_position)/randi_range(3, 6)
	breakline.add_point(breaking_point, 1)
	var f := 62
	breakline.add_point(breaking_point + Vector2(randi_range(-f,f), randi_range(-f,f)), 1)
	breakline.add_point(breaking_point2 - Vector2(randi_range(-f,f), randi_range(-f,f)), 1)
	

func evade():
	#TODO: implement
	
	pass

func hurt():
	#TODO: add stuff before enemy dies
	enemy_sprite.hide()
	queue_free()
	#print("enemy hurt")
