extends Node2D


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		for enemy in get_tree().get_nodes_in_group("enemy"):
			enemy.do_break_effect()
