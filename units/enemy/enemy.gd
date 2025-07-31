extends Node2D
class_name Enemy

signal targeted(unit)
signal hp_changed(new_value)
signal died(unit)

enum STATES{
	ALIVE,
	DEAD
}
@onready var current_state: STATES = STATES.ALIVE

@onready var max_hp: int = 100
@onready var current_hp: int = 100:
	set(value):
		current_hp = value
		if current_hp > max_hp:
			current_hp = max_hp
		hp_changed.emit(current_hp)


@onready var attack: int = 100
@onready var defense: int = 10


func _process(delta: float) -> void:
	match current_state:
		STATES.ALIVE:
			alive()
		STATES.DEAD:
			dead()


func alive():
	pass

func dead():
	died.emit(self)

func take_damage(damage) -> void:
	var total_damage = ceil(damage - defense)
	current_hp -= (damage - defense)


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("CLICKADO")
		targeted.emit(self)
