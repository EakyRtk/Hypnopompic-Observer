extends CharacterBody2D


const SPEED = 100.0

func _physics_process(_delta):

	var direction = global_position.direction_to(get_global_mouse_position())

	velocity = direction * SPEED
	move_and_slide()
