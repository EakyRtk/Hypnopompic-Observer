extends Node

var camera 
var player : CharacterBody2D
var checkpoint := 0
var hit_score := 0
var temp_hit_score := 0

func update_score_and_checkpoint() -> void:
	hit_score += temp_hit_score
	temp_hit_score = 0
	checkpoint += 1
