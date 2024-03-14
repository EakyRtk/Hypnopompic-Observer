extends Node2D

@export var sequence_player : AnimationPlayer
var on_sequence := false
var ded := false
@onready var try = $try


func start_sequence() -> void:
	on_sequence = true
	General.player.can_move = true
	sequence_player.play("0")
	sequence_player.queue("1")
	print(sequence_player.get_queue())

func update_call() -> void:
	General.update_score_and_checkpoint()
	
func _unhandled_input(event):
	if ded and event.is_action_pressed("breakskill"):
		ded = false
		go_back_checkpoint()
		General.player.switch_process_state(true)

func go_back_checkpoint() -> void:
	try.visible = false
	
	for i in get_tree().get_nodes_in_group("enemy"):
		i.hurt()
	for i in get_tree().get_nodes_in_group("bullet"):
		i.queue_free()
	print(str(General.checkpoint))
	sequence_player.play(str(General.checkpoint))
	General.player.position = Vector2(960, 540)
	print("im called")

func _on_player_stop_sequence():
	freeze_enemies()
	try.visible = true
	ded = true
	sequence_player.stop()

func final_stage() -> void:
	General.player.full_stop()

func print_state() -> void:
	print(str(General.checkpoint))
	print(sequence_player.get_queue())


func freeze_enemies() -> void:
	for i in get_tree().get_nodes_in_group("enemy"):
		i.freeze()


func _on_animation_changed(_old_name, _new_name):
	update_call()
	print_state()
	
