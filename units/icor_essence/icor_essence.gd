extends Node2D

signal ended()

@export var icor_amount: int = 0

@export var target_pos: int = 100
@export var life_time: float = 1

func _ready():
	var tween = create_tween()
	var target_position = global_position + Vector2(0, -target_pos)
	tween.tween_property(self, "global_position", target_position, life_time)
	tween.tween_callback(Callable(self, "erase_icor"))

func break_icor() -> void:
	print("ICOR ROTO")
	ProgressManager.current_icor -= icor_amount
	ProgressManager.player_ref.drain_icor(icor_amount)
	ended.emit()
	queue_free()

func erase_icor() -> void:
	ended.emit()
	queue_free()

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		break_icor()
