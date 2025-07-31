extends Node2D

enum STATES{
	PLAYER_TURN,
	ENEMY_TURN,
	QUICK_BREAK
}

@onready var current_state: STATES = STATES.PLAYER_TURN
@onready var attack_targeting: bool = false
@onready var enemies: Array = []
@onready var player: Player
@onready var target: Enemy
@onready var battle_ui: Control = $CanvasLayer/BattleUI

func _ready() -> void:
	player = $Player
	enemies.append($Enemy)
	for enemy in enemies:
		enemy.connect("targeted", enemy_targeted)
	
	battle_ui.connect("attack_pressed", enable_attack)

func _process(delta: float) -> void:
	match current_state:
		STATES.PLAYER_TURN:
			player_turn()
		STATES.ENEMY_TURN:
			enemy_turn()
		STATES.QUICK_BREAK:
			quick_break()

func change_state(new_state: STATES) -> void:
	current_state = new_state

func player_turn() -> void:
	
	if attack_targeting:
		print("ESCOGIENDO OBJETIVO DE ATAQUE")
		if Input.is_action_just_pressed("cancel_target"):
			attack_targeting = false

func enemy_turn() -> void:
	pass

func quick_break() -> void:
	pass

func enable_attack() -> void:
	attack_targeting = true

func enemy_targeted(enemy) -> void:
	if attack_targeting:
		print("OBJETIVO FIJADO" + str(enemy))
		target = enemy
	print("NO SE PUEDE FIJAR")

func player_attack() -> void:
	enemies[target]
