extends Node2D

@export var bullet_speed := 190

func _process(delta):
	position += position.direction_to(Vector2(960, 540)) * delta * bullet_speed

func hurt():
	#TODO: add stuff before deletion from the scene
	queue_free()
