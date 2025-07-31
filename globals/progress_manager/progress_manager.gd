extends Node

@onready var ruin_level: Dictionary = {
	20000 : 0,
	18000 : 1,
	15000 : 2,
	10000 : 3,
	5000 : 4,
	1000 : 5,
	0: 6
}

@onready var current_level: int = 0

@export var total_icor: int = 20000
@export var current_icor: int = 20000




func break_icor(amount) -> void:
	current_icor -= amount
	var keys := ruin_level.keys()
	keys.sort()
	keys.reverse()

	for icor in keys:
		if current_icor >= icor:
			level_up(ruin_level[icor])
			break


func level_up(new_level) -> void:
	current_level = new_level
