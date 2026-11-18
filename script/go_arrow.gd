extends TextureRect

@onready var go_sound: AudioStreamPlayer = $AudioStreamPlayer



func _ready() -> void:
	hide()
	
	
	
func _on_camera_path_moved() -> void:
	show()
	modulate.a = 0.0
	var tween: Tween = create_tween()
	tween.set_loops(3)
	tween.tween_property(self, "modulate:a", 1.0, 0.2).from(0)
	tween.tween_callback(go_sound.play)
	#tween.tween_property(self, "modulate:a", 0.0, 0.2)


#func _on_camera_path_stopped() -> void:
	#hide()


func _on_camera_path_changed() -> void:
	hide()
