extends CharacterBody2D

@onready var hurtbox_shape: CollisionShape2D = $HurtBox/CollisionShape2D

func attack() -> void:
	hurtbox_shape.disabled
	await get_tree().create_timer(0.2).timeout
	
	
func _on_hurtbox_area_entered(area: Area2D) -> void:
	EventBus.attacked.emit(self, area, 10)
	print()
