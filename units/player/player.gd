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
		if !limit_broken:
			update_stats()

@onready var max_icor: int = 9999
@onready var current_icor: int = 0:
	set(value):
		current_icor = value
		if current_icor > max_icor:
			current_icor = max_icor
		icor_changed.emit(current_icor)
		if !limit_broken:
			update_stats()

@onready var attack: int = 0
@onready var defense: int = 0
@onready var limit_broken: bool = false

## ANIMACIONES
@onready var idle: AnimatedSprite2D = $Idle
@onready var jump: AnimatedSprite2D = $Jump
@onready var pray: AnimatedSprite2D = $Pray
@onready var basic_attack: AnimatedSprite2D = $BasicAttack
@onready var death: AnimatedSprite2D = $Death
@onready var hit: AnimatedSprite2D = $Hurt

@onready var target_jump: Vector2
@onready var player_pos: Vector2 = global_position

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

func beyond() -> void:
	limit_broken = true
	current_hp = max_hp
	attack = 9999
	defense = 500


func animate(animation: String) -> void:
	match animation:
		"attack":
			idle.hide()
			basic_attack.show()
			basic_attack.play()
			await basic_attack.animation_finished
			idle.show()
			basic_attack.hide()
		"hit":
			idle.hide()
			hit.show()
			hit.play()
			await hit.animation_finished
			idle.show()
			hit.hide()
		"Death":
			idle.hide()
			death.show()
			death.play()
			await death.animation_finished
		"jump":
			idle.hide()
			jump.show()
			var tween = create_tween()
			tween.tween_property(self, "global_position", target_jump, 0.7)
			jump.play()
			await jump.animation_finished
			jump.hide()
		"return_jump":
			idle.hide()
			jump.show()
			var tween = create_tween()
			tween.tween_property(self, "global_position", player_pos, 0.7)
			jump.play_backwards()
			await jump.animation_finished
			idle.show()
			jump.hide()
