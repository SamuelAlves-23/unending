extends Node2D
class_name Player

signal hp_changed(new_value)
signal icor_changed(new_value)
signal died()



enum STATES{
	ALIVE,
	DEAD
}
@onready var current_state: STATES = STATES.ALIVE

@onready var max_hp: int = 9999
@onready var current_hp: int = 750:
	set(value):
		current_hp = value
		if current_hp > max_hp:
			current_hp = max_hp
		hp_changed.emit(current_hp)
		update_stats()

@onready var max_icor: int = 9999
@onready var current_icor: int = 0:
	set(value):
		current_icor = value
		if current_icor > max_icor:
			current_icor = max_icor
		icor_changed.emit(current_icor)
		update_stats()

@onready var attack: int = 0
@onready var defense: int = 0


func _ready() -> void:
	ProgressManager.player_ref = self
	update_stats()

func _process(delta: float) -> void:
	match current_state:
		STATES.ALIVE:
			alive()
		STATES.DEAD:
			dead()

func update_stats() -> void:
	attack = ceil(current_hp * 1.2)
	defense = ceil(current_icor * 0.2)

func alive():
	pass

func dead():
	died.emit()

func take_damage(damage) -> void:
	var total_damage = ceil(damage - defense)
	current_hp -= (damage - defense)
	print(str(current_hp) + "/" + str(max_hp) + " HP")

func drain_icor(amount) -> void:
	current_icor += amount
	print(str(current_icor) + "/" + str(max_icor) + " ICOR")
