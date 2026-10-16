class_name EntityComponent
extends Node

@export var entity_name: String
@export var entity_icon: Texture2D
@export var entity_parent: Node
@export var health: int = 100
@export var max_health: int = 100
@export var hitbox: Area2D
@onready var hurtbox_shape: CollisionShape2D = $"../HurtBox/CollisionShape2D"

func _ready() -> void:
	EventBus.attacked.connect(_on_attacked)
	
	
func _on_attacked(source: Node, target: Node, damage: float) -> void:
	if target == hitbox:
		health -= damage
		EventBus.entity_attacked.emit(self)
		if health <=0:
			entity_parent.queue_free()
			
