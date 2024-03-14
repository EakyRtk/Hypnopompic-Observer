extends CharacterBody2D

signal shake_camera
signal stop_sequence

const PLAYER_BULLET = preload("res://Player/PlayerBullet/player_bullet.tscn")
const EYE_OPEN = preload("res://Player/eye_real.png")
const EYE_REAL_CLOSED = preload("res://Player/eye_real_closed.png")



enum sequence_at {first, second, final}
enum hurted_type {Enemy, Player, Area, OneShot}

@onready var direction_line = $Direction
@onready var break_ulti = $BreakUlti
@onready var breaking = $break
@onready var dash_cooldown_timer = $FirstSequence/DashCooldown
@onready var dash_recover_timer = $FirstSequence/DashRecover
@onready var eyepupil = $General/eye/eyepupil
@onready var eye_b = $FirstSequence/EyeB

@onready var shoot = $shoot
@onready var gothurt = $gothurt


@onready var health_regen_timer = $SecondSequence/HealthRegen

@onready var health_bar = $SecondSequence/HealthBar
@onready var dashnshield = $SecondSequence/Dashnshield
@onready var dashrecover = $SecondSequence/Dashrecover
@onready var break_cooldown = $BreakCooldown
@onready var eye_open_timer = $EyeOpenTimer

@onready var hitcollision = $HitBox/CollisionShape2D
@export var player_sequence : sequence_at = sequence_at.first
@export var camera : Node2D
@export var dash_cooldown := 5.5
@export var br_cooldown := 15.0
var sleeping := false
var speed = 700

#INFO: for controller
var looking_direction := Vector2(1, 0)


@export var can_take_damage := false
var health := 100
var health_regen_amount := 3

@export var can_move := false
var dashnshielding := false
@export var can_break := false
@export var can_shoot := false

func _ready():
	dashnshield.max_value = dash_cooldown
	dashnshield.value = dash_cooldown
	
	dashrecover.max_value = dash_cooldown
	
	General.player = self
	shake_camera.connect(camera.apply_shake)
	if player_sequence == sequence_at.second:
		health_regen_timer.start(5)

func _physics_process(_delta):
	_movement()

func _process(_delta):
	dashnshield.value = dash_cooldown_timer.time_left
	dashrecover.value = dash_recover_timer.time_left
	health_bar.value = health
	if Input.get_connected_joypads() > [0]:
		direction_line.visible = true
		direction_line.set_point_position(1, looking_direction.normalized() * 100)

func sleep_again()->void:
	sleeping = true
	can_take_damage = false
	eye_b.texture = EYE_REAL_CLOSED
	speed = 100
	await get_tree().create_timer(2).timeout
	set_process(false)
	set_process_input(false)
	set_physics_process(false)
	var tweeeen = create_tween()
	tweeeen.tween_property(self, "position", Vector2(1920/2, 1080/2), 3)
	

#INFO: its hell down there	
func _input(event):
	looking_direction = looking_direction.lerp(Vector2(Input.get_joy_axis(0, JOY_AXIS_RIGHT_X), Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)), 0.1) 
	if can_break and event.is_action_pressed("breakskill"):
		if get_tree().get_nodes_in_group("enemy") == []:
			return
		break_ulti.visible = false
		can_move = false
		breaking.play()
		emit_signal("shake_camera")
		var pupiltween = create_tween()
		pupiltween.tween_property(eyepupil, "scale", Vector2.ONE * 0.7, 0.2)
		pupiltween.tween_property(eyepupil, "scale", Vector2.ONE * 1.5, 4)
		can_break = false
		break_cooldown.start(br_cooldown)
		for enemy in get_tree().get_nodes_in_group("enemy"):
			await get_tree().create_timer(0.03).timeout
			if enemy != null:
				enemy.do_break_effect()
		for bullet in get_tree().get_nodes_in_group("bullet"):
			bullet.queue_free()
		can_move = true
		
		
	if event.is_action_pressed("dashnshield"):
		_hitbox_expansion()
		
	if can_shoot and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				shoot.play()
				var n_bullet = PLAYER_BULLET.instantiate()
				n_bullet.top_level = true
				n_bullet.global_position = global_position
				n_bullet.direction = global_position.direction_to(get_global_mouse_position())
				n_bullet.z_index = -2
				add_child(n_bullet)
				
	if event.is_action_pressed("shoot"):
		shoot.play()
		var n_bullet = PLAYER_BULLET.instantiate()
		n_bullet.top_level = true
		n_bullet.global_position = global_position
		n_bullet.direction = looking_direction.normalized()
		add_child(n_bullet)
		
#will only work in second part
func _movement() -> void:
	if not can_move or not player_sequence == sequence_at.second:
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
	
func hurt(areaType : hurted_type) -> void:
	match areaType:
		hurted_type.Enemy:
			gothurt.play()
			eye_b.texture = EYE_REAL_CLOSED
			eye_open_timer.start(3)
			General.camera.apply_shake(10.0, 10.0)	
			General.temp_hit_score += 1
			if not can_take_damage:
				return
			health -= 5
			health_bar.value = health
			
		hurted_type.Area:
			gothurt.play()
			health -= 50
			eye_b.texture = EYE_REAL_CLOSED
			eye_open_timer.start(3)
			General.camera.apply_shake(10.0, 10.0)

			General.temp_hit_score += 1
			
		hurted_type.OneShot:
			General.camera.apply_shake(10.0, 10.0)
			_die()
			General.temp_hit_score = 0
			return
	
	
	
	if player_sequence == sequence_at.second and health <= 0:
		General.temp_hit_score = 0
		_die()

func _die() -> void:
	switch_process_state(false)
	emit_signal("stop_sequence")

func _on_health_regen() -> void:
	if health <= 100 - health_regen_amount:
		health += health_regen_amount

func switch_process_state(state: bool) -> void:
	if state:
		health = 100
	visible = state
	set_process(state)
	set_process_input(state)
	set_physics_process(state)

func _on_dash_cooldown_timeout() -> void:
	dashnshield.visible = false
	dashnshield.value = dash_cooldown
	hitcollision.shape.set_deferred("radius", 66)
	speed = 600
	dash_recover_timer.start(dash_cooldown)
	
func change_sequence() -> void:
	player_sequence = sequence_at.second

func can_i_move(answer: bool) -> void:
	can_move = answer

func change_break(can_i_break_now: bool) -> void:
	can_break = can_i_break_now

func _on_dash_recover_timeout() -> void:
	dashrecover.value = 0
	dashnshielding = false

func _on_break_cooldown_timeout():
	break_ulti.visible = true
	can_break = true


func _on_eye_open_timer_timeout():
	if sleeping:
		return
	eye_b.texture = EYE_OPEN
