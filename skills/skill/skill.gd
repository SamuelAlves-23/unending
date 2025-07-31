extends Node
class_name Skill

@export var skill_name: String
@export var cost: int
#@onready var animation: PackedScene

func effect() -> void:
	print("EFECTO DE HABILIDAD")
