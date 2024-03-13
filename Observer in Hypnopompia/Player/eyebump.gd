extends CharacterBody2D


const SPEED = 120.0

func _physics_process(_delta):
	if global_position.distance_to(get_global_mouse_position()) > 2:
		var direction = global_position.direction_to(get_global_mouse_position())

		velocity = direction * SPEED
		move_and_slide()
