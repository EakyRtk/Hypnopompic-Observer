extends Camera2D

@export var rStrength := 20.0
@export var shakeFade := 5.0

var rng = RandomNumberGenerator.new()

var shake_strength := 0.0

func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		
		offset = randomOffset()

func apply_shake() -> void:
	shake_strength = rStrength
	
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
