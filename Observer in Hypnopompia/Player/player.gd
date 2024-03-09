extends CharacterBody2D

signal shake_camera

const PLAYER_BULLET = preload("res://Player/PlayerBullet/player_bullet.tscn")

enum sequence_at {first, second, final}
enum hurted_type {Enemy, Player, Area, OneShot}

@onready var dash_cooldown_timer = $FirstSequence/DashCooldown
@onready var dash_recover_timer = $FirstSequence/DashRecover

@onready var health_regen_timer = $SecondSequence/HealthRegen

@onready var health_bar = $SecondSequence/HealthBar
@onready var dashnshield = $SecondSequence/Dashnshield
@onready var dashrecover = $SecondSequence/Dashrecover

@onready var hitcollision = $HitBox/CollisionShape2D
@export var player_sequence : sequence_at = sequence_at.first
@export var camera : Camera2D
@export var dash_cooldown := 5.5

var speed = 700

var health := 100
var health_regen_amount := 3

var dashnshielding := false

func _ready():
	dashnshield.max_value = dash_cooldown
	dashnshield.value = dash_cooldown
	
	dashrecover.max_value = dash_cooldown
	
	General.player = self
	shake_camera.connect(camera.apply_shake)
	if player_sequence == sequence_at.second:
		health_regen_timer.start(5)
		
func _input(event):
	#TODO: change it happen only after the second stage
	if event.is_action_pressed("ui_accept"):
		emit_signal("shake_camera")
		for enemy in get_tree().get_nodes_in_group("enemy"):
			enemy.do_break_effect()
		for bullet in get_tree().get_nodes_in_group("bullet"):
			bullet.queue_free()
	
	if event.is_action_pressed("dashnshield"):
		_hitbox_expansion()
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var n_bullet = PLAYER_BULLET.instantiate()
				n_bullet.top_level = true
				n_bullet.global_position = global_position
				n_bullet.direction = global_position.direction_to(get_global_mouse_position())
				add_child(n_bullet)
#will only work in second part
func _movement():
	if not player_sequence == sequence_at.second:
		return
	
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction == Vector2.ZERO and velocity != Vector2.ZERO:
		velocity = velocity.lerp(Vector2.ZERO, 0.2)
	else:
		velocity = velocity.lerp(direction * speed, 0.85) 
	move_and_slide()

func _hitbox_expansion() -> void:

	if dashnshielding:
		return
	dashnshield.visible = true
	dashnshielding = true
	speed = 770
	hitcollision.shape.set_deferred("radius", 123)
	dash_cooldown_timer.start(dash_cooldown)

func _physics_process(_delta):
	_movement()

func _process(_delta):
	dashnshield.value = dash_cooldown_timer.time_left
	dashrecover.value = dash_recover_timer.time_left
	health_bar.value = health
			
func hurt(areaType : hurted_type):
	match areaType:
		hurted_type.Enemy:
			health -= 5
			health_bar.value = health
			pass
		hurted_type.Area:
			print("took area damage")
			pass
		hurted_type.OneShot:
			print("one shotted")
			pass
	#TODO: implement whats gonna happen in s_1 and s_2 
	pass



func _on_dash_cooldown_timeout():
	dashnshield.visible = false
	dashnshield.value = dash_cooldown
	hitcollision.shape.set_deferred("radius", 66)
	speed = 600
	dash_recover_timer.start(dash_cooldown)
	


func _on_dash_recover_timeout():
	dashrecover.value = 0
	dashnshielding = false


func _on_health_regen():
	if health <= 100 - health_regen_amount:
		health += health_regen_amount
