extends CharacterBody2D

@export var speed: float = 300

var input_direction: Vector2 = Vector2.ZERO
@onready var hurtbox_shape: CollisionShape2D = $Hurtbox/CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _ready() -> void:
	EventBus.player_requested.connect(_on_player_requested)
	hurtbox_shape.disabled = true
	

func _physics_process(delta: float) -> void:
	input_direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = input_direction * speed
	move_and_slide()

	if Input.is_action_just_pressed("attack"):
		attack()
	
	
func attack() -> void:
	animation_player.play("attack")
	animation_player.animation_finished.connect(func(a):animation_player.play("idle"), CONNECT_ONE_SHOT)
	hurtbox_shape.disabled = false
	await  get_tree().create_timer(0.2).timeout
	hurtbox_shape.disabled = true


func _on_player_requested(enemy: Enemy) -> void:
	enemy.player = self



func _on_hurtbox_area_entered(area: Area2D) -> void:
	EventBus.attacked.emit(self, area, 10)

func died() -> void:
	pass
