class_name HealthDisplayComponent
extends Node

@export var health_panel: PanelContainer
@export var icon: TextureRect
@export var display_label: Label
@export var health_bar: ProgressBar


func _ready() -> void:
	EventBus.entity_attacked.connect(_on_entity_attacked)


func _on_entity_attacked(entity: EntityComponent) -> void:
	health_bar.max_value = entity.max_health
	health_bar.value = entity.health
	icon.texture = entity.entity_icon
	display_label.text = entity.entity_name
