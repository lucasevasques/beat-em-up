extends CharacterBody2D

@export var speed: float = 300

var input_direction: Vector2 = Vector2.ZERO
@onready var hurtbox_shape: CollisionShape2D = $Hurtbox/CollisionShape2D



func _ready() -> void:
	hurtbox_shape.disabled = true
	

func _physics_process(delta: float) -> void:
	input_direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = input_direction * speed
	move_and_slide()

	if Input.is_action_just_pressed("attack"):
		attack()
	
	
func attack() -> void:
	hurtbox_shape.disabled = false
	await  get_tree().create_timer(0.2).timeout
	hurtbox_shape.disabled = true


func _on_hurtbox_area_entered(area: Area2D) -> void:
	EventBus.attacked.emit(self, area, 10)
