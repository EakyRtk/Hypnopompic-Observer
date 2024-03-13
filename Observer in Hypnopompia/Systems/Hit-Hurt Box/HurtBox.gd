class_name HurtBox extends Area2D

enum DetectType {TypHurt, TypEvade}
enum hurted_type {Enemy, Player, Area, OneShot}
@export_enum("Enemy", "Player") var hurt_from = 1
@export var detect_type : DetectType = DetectType.TypHurt
var parent

func _init():
	monitorable = false
	collision_layer = 0
	collision_mask = 2

func _ready():
	self.area_entered.connect(_hurt)
	parent = get_parent()
	
func _hurt(area: HitBox):
	if detect_type == DetectType.TypEvade and parent.has_method("evade") and area.type == hurt_from:
		parent.evade()
		return
	
	#NOTE: It's stupid but whatever, it works.
	if area.type == hurt_from and parent.has_method("hurt"):
		#print("called hurt on parent")
		if parent.is_in_group("player"):
			parent.hurt(area.type)
			return
		parent.hurt()
		return
	if area.type == hurted_type.Area or area.type == hurted_type.OneShot:
		if parent.is_in_group("player"):
			parent.hurt(area.type)
			return
		
	
