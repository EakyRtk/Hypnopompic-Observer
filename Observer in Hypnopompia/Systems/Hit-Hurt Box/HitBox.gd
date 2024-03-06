class_name HitBox extends Area2D

@export_enum("Enemy","Player") var type = 0

func _init():
	monitoring = false
	collision_layer = 2
	collision_mask = 0
