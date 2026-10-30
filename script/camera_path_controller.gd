extends Path2D

signal stopped

enum CameraState {STOP, MOVE}

@export var player: Node2D
@export var stop_index: int = 0
@export var stop_positions: Array[float]

@onready var camera_target: PathFollow2D = $CameraTarget
@onready var camera_bounds: StaticBody2D = $CameraTarget/Camera2D/CameraBounds

var origin: Vector2
var current_state: CameraState = CameraState.STOP


func _ready() -> void:
	origin = curve.get_point_position(0)
	await get_tree().physics_frame
	stopped.emit()
	
func _physics_process(delta: float) -> void:
	match current_state:
		CameraState.STOP:
			handle_stop(delta)
		CameraState.MOVE:
			handle_move(delta)
	
	
func handle_stop(delta: float) -> void:
	pass
	
	
func handle_move(delta: float) -> void:
	if player == null:
		return
	var target_position: Vector2 = player.global_position - origin 
	target_position.x = clampf(target_position.x, 0, curve.get_point_position(2).x - origin.x)
	camera_target.progress = target_position.x
	if camera_target.progress >= stop_positions[stop_index]:
		current_state = CameraState.STOP
		stopped.emit()


func _on_horde_finished() -> void:
	stop_index += 1
	if stop_index > stop_positions.size() - 1:
		printerr("No more camera stops!") #camera chegou ao fim
		#TODO FIM DA FASE, TROCAR DE FASE
		return
	current_state = CameraState.MOVE
