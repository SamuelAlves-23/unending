extends Node2D

enum STATES{
	PLAYER_TURN,
	ENEMY_TURN,
	QUICK_BREAK
}

@onready var current_state: STATES = STATES.PLAYER_TURN
@onready var attack_targeting: bool = false
@onready var enemies: Array = [Enemy]

@onready var battle_ui: Control = $CanvasLayer/BattleUI

func _ready() -> void:
	enemies.append($Enemy)
	battle_ui.connect("attack_pressed", enable_attack)

func _process(delta: float) -> void:
	match current_state:
		STATES.PLAYER_TURN:
			player_turn()
		STATES.ENEMY_TURN:
			enemy_turn()
		STATES.QUICK_BREAK:
			quick_break()

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
