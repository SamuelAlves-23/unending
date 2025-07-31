extends Node2D

enum STATES{
	PLAYER_TURN,
	ENEMY_TURN,
	QUICK_BREAK
}

@onready var current_state: STATES = STATES.PLAYER_TURN
@onready var attack_targeting: bool = false
@onready var enemies = []
@onready var player: Player
@onready var target: Enemy
@onready var battle_ui: Control = $CanvasLayer/BattleUI

func _ready() -> void:
	player = $Player
	enemies.append($Enemy)
	for enemy in enemies:
		enemy.connect("targeted", enemy_targeted)
		enemy.connect("died", erase_enemy)
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
	for enemy in enemies:
		enemy.action()
	change_state(STATES.PLAYER_TURN)

func quick_break() -> void:
	pass

func enable_attack() -> void:
	if current_state == STATES.PLAYER_TURN:
		attack_targeting = true

func enemy_targeted(enemy) -> void:
	if attack_targeting:
		print("OBJETIVO FIJADO" + str(enemy))
		target = enemy
		player_attack()
	print("NO SE PUEDE FIJAR")

func erase_enemy(enemy) -> void:
	enemy.queue_free()
	enemies.erase(enemy)

func player_attack() -> void:
	var total_damage = randi_range(player.attack * 0.9, player.attack * 1.1)
	target.take_damage(total_damage)
	target = null
	if enemies.size() > 0:
		change_state(STATES.ENEMY_TURN)
