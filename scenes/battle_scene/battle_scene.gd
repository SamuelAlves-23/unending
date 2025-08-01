extends Node2D

enum STATES{
	PLAYER_TURN,
	CHECK,
	ENEMY_TURN,
	QUICK_BREAK
}

@onready var skill_costs: Dictionary = {
	"strike" : 250,
	"slash" : 1000,
	"regeneration" : 0,
	"beyond" : 6000,
	"end" : 9999
}

@onready var current_state: STATES = STATES.PLAYER_TURN
@onready var attack_targeting: bool = false
@onready var enemies = []
@onready var player: Player
@onready var target: Enemy
@onready var battle_ui: Control = $CanvasLayer/BattleUI

@onready var striking: bool = false
@onready var first: bool = true

func _ready() -> void:
	player = $Player
	enemies.append($Enemy)
	enemies.append($Enemy2)
	enemies.append($Enemy3)
	
	for enemy in enemies:
		enemy.connect("targeted", enemy_targeted)
		enemy.connect("died", erase_enemy)
	battle_ui.connect("attack_pressed", enable_attack)

func _process(delta: float) -> void:
	match current_state:
		STATES.PLAYER_TURN:
			player_turn()
		STATES.CHECK:
			check()
		STATES.ENEMY_TURN:
			enemy_turn()
		STATES.QUICK_BREAK:
			quick_break()

func change_state(new_state: STATES) -> void:
	first = true
	attack_targeting = false
	current_state = new_state

func player_turn() -> void:
	if first:
		first = false
		check_upgrades()
	
	if attack_targeting:
		print("ESCOGIENDO OBJETIVO DE ATAQUE")
		if Input.is_action_just_pressed("cancel_target"):
			attack_targeting = false
			striking = false

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
		target = enemy
		if striking:
			strike()
		else:
			player_attack()
	else:
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

func check_skill(skill: String) -> void:
	if skill_costs[skill] <= ProgressManager.player_ref.current_icor:
		match skill:
			"strike":
				strike_target()
			"slash":
				slash()
			"regeneration":
				regeneration()
			"beyond":
				beyond()
			"end":
				end()

func check() -> void:
	check_upgrades()
	

func strike_target() -> void:
	if current_state == STATES.PLAYER_TURN:
		attack_targeting = true
		striking = true

func strike() -> void:
	print("ICOR STRIKE")
	var total_damage = randi_range(player.attack * 0.9, player.attack * 1.1) * 2
	player.current_icor -= 500
	target.take_damage(total_damage)
	target = null
	change_state(STATES.CHECK)

func slash() -> void:
	print("ICOR SLASH")
	var total_damage = randi_range(player.attack * 0.9, player.attack * 1.1) * 1.2
	player.current_icor -= 1000
	for enemy in enemies:
		enemy.take_damage(total_damage)
	change_state(STATES.CHECK)

func regeneration() -> void:
	var amount = ceil(player.current_icor / 2)
	player.current_icor -= amount
	player.current_hp += amount
	change_state(STATES.CHECK)

func beyond() -> void:
	player.beyond()

func end() -> void:
	print("ULTIMATE END")
	var total_damage = randi_range(player.attack * 0.9, player.attack * 1.1) * 9999
	player.current_icor -= 9999
	for enemy in enemies:
		enemy.take_damage(total_damage)
	change_state(STATES.CHECK)

func check_upgrades() -> void:
	if player.current_icor >= 1000:
		battle_ui.unlock_skill("strike")
	if player.current_icor >= 2000:
		battle_ui.unlock_skill("slash")
	if player.current_icor >= 4000:
		battle_ui.unlock_skill("regeneration")
	if player.current_icor >= 6000:
		battle_ui.unlock_skill("beyond")
	if player.current_icor >= 9999 and player.current_hp >= 9999:
		battle_ui.unlock_skill("end")
