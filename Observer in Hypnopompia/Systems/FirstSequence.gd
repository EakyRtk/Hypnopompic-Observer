extends Node2D


func freeze_enemies() -> void:
	for i in get_tree().get_nodes_in_group("enemy"):
		i.freeze()
