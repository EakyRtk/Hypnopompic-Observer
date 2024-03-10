extends Node2D

@onready var second_sequence_anim = $SecondSequencePlayer
var on_sequence := false
var ded := false

func start_second_sequence() -> void:
	on_sequence = true
	second_sequence_anim.play("0")
	second_sequence_anim.queue("1")
	second_sequence_anim.queue("2")

func update_call() -> void:
	General.update_score_and_checkpoint()
	
func _unhandled_input(event):
	if ded and event.is_action_pressed("breakskill"):
		ded = false
		go_back_checkpoint()
		General.player.switch_process_state(true)

func go_back_checkpoint() -> void:
	for i in get_tree().get_nodes_in_group("enemy"):
		i.hurt()
	for i in get_tree().get_nodes_in_group("bullet"):
		i.queue_free()
	print(str(General.checkpoint))
	second_sequence_anim.play(str(General.checkpoint))
	print("im called")

func _on_player_stop_sequence():
	ded = true
	second_sequence_anim.stop()

func final_stage() -> void:
	General.player.full_stop()

func print_state() -> void:
	print(str(General.checkpoint))
	print(second_sequence_anim.get_queue())

func _on_second_sequence_player_animation_changed(old_name, new_name):
	print_state()
	update_call()
