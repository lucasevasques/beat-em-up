class_name Enemy
extends CharacterBody2D

@onready var hurtbox_shape: CollisionShape2D = $HurtBox/CollisionShape2D

var player: CharacterBody2D
var is_player_available: bool = false

var target_acquired_elapsed: float = 0

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D


func _ready() -> void:
	await  get_tree().physics_frame
	EventBus.player_requested.emit(self)
	is_player_available = true


func _physics_process(delta: float) -> void:
	if is_player_available == false:
		return
	
	if target_acquired_elapsed > 1:
		nav_agent.target_position = player.global_position
		target_acquired_elapsed = 0
	
	var next_position: Vector2 = nav_agent.get_next_path_position()
	velocity = global_position.direction_to(next_position) * 50
	move_and_slide()
	
	target_acquired_elapsed += delta



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
