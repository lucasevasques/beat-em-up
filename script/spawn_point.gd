class_name SpawnPoint
extends Marker2D


signal entity_destroyed

@export var entity_scene: PackedScene
@export var horde: int = 0

func spawn() -> void:
	var entity: Node2D = entity_scene.instantiate()
	add_child(entity)
	entity.tree_exited.connect(entity_destroyed.emit)
