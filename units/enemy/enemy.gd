extends Node2D
class_name Enemy

signal targeted(unit)
signal hp_changed(new_value)
signal died(unit)

@onready var icor_essence: PackedScene = preload("res://units/icor_essence/icor_essence.tscn")

@export var max_hp: int = 100
@export var current_hp: int = 100:
	set(value):
		current_hp = value
		if current_hp > max_hp:
			current_hp = max_hp
		if current_hp <= 0:
			die()
		hp_changed.emit(current_hp)

@export var icor_value: int = 100
@export var attack: int = 100
@export var defense: int = 10

func action() -> void:
	print("ACCIONES ENEMIGA")

func die() -> void:
	var icor = icor_essence.instantiate()
	icor.icor_amount = icor_value
	icor.global_position = global_position
	get_parent().add_child(icor)
	died.emit(self)

func take_damage(damage) -> void:
	var total_damage = ceil(damage - defense)
	current_hp -= total_damage
	print(str(current_hp) + "/" + str(max_hp) + " HP")


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("CLICKADO")
		targeted.emit(self)
