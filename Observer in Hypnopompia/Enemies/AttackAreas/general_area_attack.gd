extends Node2D

@export_enum("Area", "OneShot") var type := 0
@onready var hit_box = $HitBox

func _ready():
	hit_box.type += type
	
func change_type(new_type):
	type = new_type
	hit_box.type = type
