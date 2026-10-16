extends Path2D

@export var player: Node2D
@export var stop_index: int = 0
@export var stop_positions: Array[float]

@onready var camera_target: PathFollow2D = $CameraTarget

var origin: Vector2

func _ready() -> void:
	origin = curve.get_point_position(0)
	
func _physics_process(delta: float) -> void:
	var target_position: Vector2 = player.global_position - origin 
	target_position.x = clampf(target_position.x, 0, curve.get_point_position(2).x - origin.x)
	camera_target.progress = target_position.x
	
