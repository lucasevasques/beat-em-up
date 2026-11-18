extends Control


func _ready() -> void:
	AudioServer.set_bus_volume_linear(1, 1.0)
	
	
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/gym.tscn")


func _on_fullscreen_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
