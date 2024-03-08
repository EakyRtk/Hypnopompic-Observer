extends Node2D

signal shake_camera

const PLAYER_BULLET = preload("res://Player/PlayerBullet/player_bullet.tscn")

enum sequence_at {first, second, final}
@export var player_sequence : sequence_at = sequence_at.first
@export var camera : Camera2D

func _ready():
	shake_camera.connect(camera.apply_shake)

func _input(event):
	#TODO: change it happen only after the second stage
	if event.is_action_pressed("ui_accept"):
		emit_signal("shake_camera")
		for enemy in get_tree().get_nodes_in_group("enemy"):
			enemy.do_break_effect()
		for bullet in get_tree().get_nodes_in_group("bullet"):
			bullet.queue_free()
			
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
	
	
	#TODO: add 4 way movement code
	pass
			
func hurt():
	print("player hurt")
	#TODO: implement whats gonna happen in s_1 and s_2 
	pass

