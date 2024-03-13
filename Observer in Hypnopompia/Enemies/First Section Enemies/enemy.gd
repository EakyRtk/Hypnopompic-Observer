extends Node2D

#INFO: enemies move towards the center gradually and evade from player bullets

static var max_evasion := 2

const S_BULLET = preload("res://Enemies/Invert Bullet/color_inverted_bullet.tscn")

@onready var enemy_sprite = $EnemySprite

@onready var sequence_cooldown = $SequenceCooldown
@onready var evasion_cooldown = $EvasionCooldown
@onready var breakline = $breakline
@onready var hit_box = $HitBox
@onready var hurt_box = $HurtBox
@onready var ripparticle = $ripparticle
@export var bullet_size := 3
@export var speed := 60
@export var rmove_range := 120

#INFO: If black enemy summons under invert area it will result an invisible enemy.
@export_enum("White/Inverted", "Black") var color_type := 0

var center := Vector2(960, 540)
var evasion := 0
var can_move := true
var no_sequence := false
var can_shoot := true
var ded_initiated := false

var random_move_tween
var break_happened := false

func _ready():

	if color_type == 1:
		modulate = Color.BLACK
		
	await get_tree().create_timer(2).timeout
	_do_sequence()

func _process(delta):
	if break_happened:
		breakline.set_point_position(0, General.player.global_position - global_position) 
	_move(delta)

#TODO: enemies will follow same sequence and fire a timer signal to redo it again
func _do_sequence() -> void:
	if no_sequence:
		return
	
	can_move = false
	_random_move()
	_shoot()
	await get_tree().create_timer(randf_range(2, 2.8)).timeout
	if no_sequence:
		return
	can_move = true
	await get_tree().create_timer(randf_range(2, 2.8)).timeout
	if no_sequence:
		return
	can_move = false
	sequence_cooldown.start()

func _move(delta):
	if not can_move or no_sequence:
		return
	position += position.direction_to(General.player.global_position) * delta * speed
	
func _random_move() -> void:
	if no_sequence or not can_move:
		return
	random_move_tween = create_tween()
	random_move_tween.tween_property(self, "position",
	 position + Vector2(randi_range(-rmove_range, rmove_range), randi_range(-rmove_range, rmove_range)), randf_range(0.9, 2.1)).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

func _shoot() -> void:
	if not can_shoot:
		return
	for i in range(3):
		var bullet = S_BULLET.instantiate()
		bullet.top_level = true
		bullet.position = position
		get_parent().add_child(bullet)
		await get_tree().create_timer(randf_range(1, 1.7)).timeout

	

func do_break_effect() -> void:
	if random_move_tween != null:
		random_move_tween.kill()
	center = General.player.global_position
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
	
	await get_tree().create_timer(0.62).timeout
	
	for points in breakline.get_point_count():
		ripparticle.position = breakline.get_point_position(breakline.get_point_count()-1)
		ripparticle.emitting = true
		await get_tree().create_timer(0.02).timeout
		breakline.remove_point(breakline.get_point_count()-1)
		#breakline.remove_point(0)
	breakline.visible = false
	General.camera.apply_shake(10.0)
	hurt()
	
func evade() -> void:
	if no_sequence:
		return
	#print("evade")
	random_move_tween = create_tween()
	random_move_tween.tween_property(self, "position",
	 position + Vector2(randf_range(-rmove_range*1.2, rmove_range*1.2), randf_range(-rmove_range*1.2, rmove_range*1.2)), randf_range(0.5, 1.0)).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	evasion_cooldown.start()

func freeze()->void:
	can_move = false
	can_shoot = false
	no_sequence = true

func hurt() -> void:
	if ded_initiated:
		return
	ded_initiated = true
	set_process(false)
	no_sequence = true
	can_move = false
	can_shoot = false
	hit_box.queue_free()
	hurt_box.queue_free()
	enemy_sprite.hide()
	General.camera.apply_shake(10.0, 10.0)
	ripparticle.emitting = true
	Engine.time_scale = 0.4
	await get_tree().create_timer(0.1).timeout
	Engine.time_scale = 1
	queue_free()
	#print("enemy hurt")


func _evasion_cooldown() -> void:
	if evasion + 1 < max_evasion:
		evasion += 1


func _on_screen_exited():
	if ded_initiated:
		return
	queue_free()
