extends CharacterBody2D

@onready var hurtbox_shape: CollisionShape2D = $HurtBox/CollisionShape2D

func attack() -> void:
	hurtbox_shape.disabled
	await get_tree().create_timer(0.2).timeout
	
	
func _on_hurtbox_area_entered(area: Area2D) -> void:
	EventBus.attacked.emit(self, area, 10)
	print()


func _on_entity_died() -> void:
	var tween: Tween = create_tween()
	
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2.ZERO, 1.0)
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	
	await tween.finished
	
	queue_free()
