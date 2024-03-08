extends Node2D

var SPEED := 800
const ACC := 20

var direction : Vector2

func _process(delta):
	if direction != null:
		SPEED += ACC
		position += direction * SPEED * delta


func _on_screen_exited():
	queue_free()
