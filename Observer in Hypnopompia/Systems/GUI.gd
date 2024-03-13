extends Control

var volumes := [0.0, 0.0, 0.0]
var adjust_amount := 2

func adjust_volume(audio_bus : int, value : float) -> void:
	volumes[audio_bus] += value
	AudioServer.set_bus_volume_db(audio_bus, volumes[audio_bus])

func mute_channel(audio_bus : int, mute : bool) -> void:
	AudioServer.set_bus_mute(audio_bus, mute)

func _on_sfx_negative_pressed():
	adjust_volume(2, -adjust_amount)


func _on_sfx_mute_toggled(toggled_on):
	mute_channel(2, toggled_on)


func _on_sfx_positive_pressed():
	adjust_volume(2, adjust_amount)



func _on_music_positive_pressed():
	adjust_volume(1, adjust_amount)

func _on_music_mute_toggled(toggled_on):
	mute_channel(1, toggled_on)

func _on_music_negative_pressed():
	adjust_volume(1, -adjust_amount)
	
	
func _on_maste_positive_pressed():
	adjust_volume(0, adjust_amount)


func _on_master_mute_toggled(toggled_on):
	mute_channel(0, toggled_on)


func _on_master_negative_pressed():
	adjust_volume(0, -adjust_amount)
