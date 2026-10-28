class_name SpawnManager
extends Node2D

signal horde_finished

var current_horde: int = 0
var current_horde_size: int = -1


func _on_camera_path_stopped() -> void:
	current_horde_size = 0
	
	for i in get_children():
		i = i as SpawnPoint
		if i.horde == current_horde:
			i.spawn()
			i.entity_destroyed.connect(_on_entity_destroyed)
			current_horde_size += 1


func _on_entity_destroyed() -> void:
	current_horde_size -= 1
	if current_horde_size <= 0:
		current_horde += 1
		horde_finished.emit()
