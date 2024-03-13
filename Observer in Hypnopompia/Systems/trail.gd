extends Line2D
class_name Trails
 
@export var MAX_POINTS := 100
@onready var curve := Curve2D.new()
 
func _ready():
	top_level = true

func _process(_delta):
 
	curve.add_point(get_parent().global_position)
	if curve.get_baked_points().size() > MAX_POINTS:
		curve.remove_point(0)
	points = curve.get_baked_points()
 
 
	
 
