extends Camera2D

@export var rStrength := 35.0
@export var shakeFade := 5.0
var sFade : float
var rng = RandomNumberGenerator.new()

var shake_strength := 0.0

#func _ready():
	#General.camera = self 
	#sFade = shakeFade
	#
#func _process(delta):
	#if shake_strength > 0:
		#shake_strength = lerpf(shake_strength, 0, sFade * delta)
	#else:
		#sFade = shakeFade
	#offset = randomOffset()

func apply_shake(sStrength = rStrength, pFade = shakeFade) -> void:
	shake_strength = sStrength
	sFade = pFade
	
	
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
