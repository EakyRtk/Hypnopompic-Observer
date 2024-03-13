extends Node2D

@onready var score_label = $CanvasLayer/GUI/ScoreLabel
@onready var first_sequence_player = $FirstSequence/FirstSequencePlayer
@onready var second_sequence = $SecondSequence
@onready var starttext = $CanvasLayer/GUI/starttext
@onready var player = $Outside/Player
@onready var sound_options = $CanvasLayer/GUI/SoundOptions

var started := false

@export var rStrength := 35.0
@export var shakeFade := 5.0
var sFade : float
var rng = RandomNumberGenerator.new()

var shake_strength := 0.0

func _ready():
	General.camera = self 
	sFade = shakeFade
	

func _process(delta):
	score_label.text = str(General.temp_hit_score + General.hit_score)
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, sFade * delta)
	else:
		sFade = shakeFade
	position = randomOffset()
	

func apply_shake(sStrength = rStrength, pFade = shakeFade) -> void:
	shake_strength = sStrength
	sFade = pFade
	
	
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

	
func _input(event):
	if not started and event is InputEventKey:
		sound_options.visible = false
		starttext.visible = false
		player.can_shoot = true
		first_sequence_player.play("first_sequence")

