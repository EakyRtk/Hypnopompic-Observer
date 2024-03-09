extends Node2D

@export var bullet_speed := 240

func _process(delta):
	position += position.direction_to(General.player.global_position) * delta * bullet_speed

func hurt() -> void:
	#TODO: add stuff before deletion from the scene
	queue_free()


func _on_screen_exited() -> void:
	queue_free()
