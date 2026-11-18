class_name AudioDirector
extends Node

@export var start_fade: bool = true


func _ready() -> void:
	if start_fade == true:
		fade(0.3, 5)


#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action("special"):
	#	Soundtrack.bus = "SoundtrackEffects"
	
	
	
func fade(volume: float, duration: float) -> void:
	var tween: Tween = create_tween()
	var current_volume: float = AudioServer.get_bus_volume_linear(1) #Soundtrack
	tween.tween_method(set_volume, current_volume, volume, duration)
	
func set_volume(volume: float) -> void:
	AudioServer.set_bus_volume_linear(1, volume)
