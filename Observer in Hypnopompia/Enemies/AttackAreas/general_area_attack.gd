extends Node2D

@export_enum("Area", "OneShot") var type := 0
@onready var hit_box = $HitBox
@onready var walls = $Walls

func _ready():
	hit_box.type += type

func set_wall_state(disable: bool) -> void:
	walls.get_child(0).set_deferred("disabled", disable)

func change_type(new_type) -> void:
	type = new_type
	hit_box.type = type
