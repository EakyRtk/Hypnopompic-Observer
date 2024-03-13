extends Node2D

@export var bullet_speed := 240
@export var acceleration := 1
@onready var bulletshatter = $bulletshatter
@onready var hurt_box = $HurtBox
@onready var hit_box = $HitBox
var color_type = 0
func _ready():
	if color_type == 1:
		modulate = Color.BLACK

func _physics_process(delta):
	bullet_speed += acceleration
	position += position.direction_to(General.player.global_position) * delta * bullet_speed

func hurt() -> void:
	hit_box.queue_free()
	hurt_box.queue_free()
	bulletshatter.play()
	await bulletshatter.finished
	#TODO: add stuff before deletion from the scene
	queue_free()

func _on_screen_exited() -> void:
	queue_free()
