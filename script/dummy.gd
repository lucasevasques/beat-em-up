class_name Enemy
extends CharacterBody2D

@onready var hurtbox_shape: CollisionShape2D = $HurtBox/CollisionShape2D

var player: CharacterBody2D
var is_player_available: bool = false

var target_acquired_elapsed: float = 0
@export var stop_distance: float = 50.0

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var icon: Sprite2D = $CollisionShape2D/Icon
@onready var hitbox: Area2D = $HitBox
@onready var hurtbox: Area2D = $HurtBox
@onready var sfx_hit: AudioStreamPlayer2D = $SFXHit


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
	
	var distance = global_position.distance_to(nav_agent.target_position)
	if distance <= 50:
		velocity = Vector2.ZERO
	
		
	move_and_slide()
	
	target_acquired_elapsed += delta
	
	if abs(velocity.x) > 0.1:
				icon.flip_h = velocity.x < 0
				
				if icon.flip_h == true:
					hurtbox.scale.x = -1
					hitbox.scale.x = -1
				else :
					hurtbox.scale.x = 1
					hitbox.scale.x = 1



func attack() -> void:
	hurtbox_shape.disabled
	await get_tree().create_timer(0.2).timeout
	
	
func _on_hurtbox_area_entered(area: Area2D) -> void:
	EventBus.attacked.emit(self, area, 10)
	


func _on_entity_died() -> void:
	var tween: Tween = create_tween()
	
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2.ZERO, 1.0)
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	
	dead_feedback()
	await tween.finished
	queue_free()
	
func hit_feedback() -> void:
	sfx_hit.play()
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.set_loops(3)
	tween.tween_property(self, "modulate", Color.WHITE, 0.2).from(Color(0.0, 0.0, 0.0, 0.0))
	tween.set_loops(1)
	tween.tween_property(self, "scale:y", scale.y, 0.2).from(scale.y * 1.2)
	
func dead_feedback() -> void:
	var tween: Tween = create_tween()
	tween.set_loops(5)
	tween.tween_property(self, "modulate",Color.WHITE,0.2).from(Color(0.0, 0.0, 0.0, 0.0))
	


func _on_damage_taken() -> void:
	hit_feedback()
