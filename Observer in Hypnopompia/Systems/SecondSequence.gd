extends Node2D

@onready var second_sequence_anim = $SecondSequencePlayer
var on_sequence := false

func start_second_sequence() -> void:
	on_sequence = true
	second_sequence_anim.play("0")

func go_back_checkpoint() -> void:
	for i in get_tree().get_nodes_in_group("enemy"):
		i.hurt()
	for i in get_tree().get_nodes_in_group("bullet"):
		i.queue_free()
	second_sequence_anim.play(str(General.checkpoint))

func _on_player_stop_sequence():
	second_sequence_anim.stop()

func final_stage() -> void:
	General.player.full_stop()
