class_name HurtBox extends Area2D

@export_enum("Enemy", "Player") var hurt_from = 1
@export_enum("HurtBox", "EvadeBox") var detect_type = 0
var parent

func _init():
	monitorable = false
	collision_layer = 0
	collision_mask = 2

func _ready():
	self.area_entered.connect(_hurt)
	parent = get_parent()
	
func _hurt(area: HitBox):
	#print("dayum")
	if area.type == hurt_from and parent.has_method("hurt"):
		#print("called hurt on parent")
		parent.hurt()
		return

