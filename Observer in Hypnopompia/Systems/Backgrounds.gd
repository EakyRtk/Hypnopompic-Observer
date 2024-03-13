extends ParallaxBackground

@export var offset_speed := 200

func _process(delta):
	scroll_offset.x -= offset_speed * delta
