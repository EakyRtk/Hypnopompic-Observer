extends Node2D

@onready var score_label = $ScoreLabel

@onready var first_sequence = $FirstSequence
@onready var textdisappertime = $textdisappertime
@onready var label = $CanvasLayer/GUI/Label

#@onready var second_sequence = $SecondSequence
@onready var starttext = $CanvasLayer/GUI/starttext
@onready var player = $Outside/Player
@onready var sound_options = $CanvasLayer/GUI/SoundOptions

var started := false

@export var rStrength := 35.0
@export var shakeFade := 5.0
var sFade : float
var rng = RandomNumberGenerator.new()
var on_fullscreen := true
var shake_strength := 0.0
var start_req := 2

func _ready():
	General.camera = self 
	sFade = shakeFade

func _input(event):
	if not started and event is InputEventKey:
		if start_req != 0:
			start_req -= 1
			return
		label.visible = true
		textdisappertime.start(5)
		started = true
		sound_options.visible = false
		player.can_shoot = true
		first_sequence.start_sequence()
		var twinn = create_tween()
		twinn.tween_property(starttext, "modulate", Color.TRANSPARENT, 2).set_trans(Tween.TRANS_QUAD)
		await twinn.finished
		starttext.visible = false
		
		
	if event.is_action_pressed("fullscreen"):
		if on_fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			on_fullscreen = !on_fullscreen
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			on_fullscreen = !on_fullscreen
		
	if event.is_action_pressed("esc"):
		get_tree().quit()

func _process(delta):
	score_label.text = "fears: " + str(General.temp_hit_score + General.hit_score)
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


func _on_textdisappertime_timeout():
	var twin = create_tween()
	twin.tween_property(label, "modulate", Color.TRANSPARENT, 0.3)
	await twin.finished
	label.visible = false
