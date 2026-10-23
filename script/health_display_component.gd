@icon("res://addons/at-icons/node/heart.svg")
class_name HealthDisplayComponent
extends Node

@export var watch_group: StringName
@export var health_panel: PanelContainer
@export var icon: TextureRect
@export var display_label: Label
@export var health_bar: ProgressBar
@export var death_cross: TextureRect
@export var hide_after_delay: bool = false
@export var hide_on_ready: bool = true
@export var refresh_on_ready: bool = false

var hud_elapsed: float = 0
var hud_delay: float = 3


func _ready() -> void:
	health_panel.visible = not hide_on_ready
	death_cross.hide()
	EventBus.entity_attacked.connect(_on_entity_attacked)
	if refresh_on_ready == true:
		EventBus.entity_ready.connect(_on_entity_ready)


func _physics_process(delta: float) -> void:
	if hide_after_delay == false:
		return
	hud_elapsed += delta
	if hud_elapsed > hud_delay and health_panel.visible == true:
		hud_elapsed = 0
		health_panel.hide()


func _on_entity_ready(entity: EntityComponent) -> void:
	if not entity.is_in_group(watch_group):
		return
		
	refresh_hud(entity)


func _on_entity_attacked(entity: EntityComponent) -> void:
	if not entity.is_in_group(watch_group):
		return
		
	hud_elapsed = 0
	health_panel.show()
		
	refresh_hud(entity)
	
	if entity.health <=0:
		death_cross.show()
	else :
		death_cross.hide()
		

func refresh_hud(entity: EntityComponent) -> void:
	health_bar.max_value = entity.max_health
	health_bar.value = entity.health
	icon.texture = entity.entity_icon
	display_label.text = entity.entity_name
