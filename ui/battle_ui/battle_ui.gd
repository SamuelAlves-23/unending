extends Control

signal attack_pressed()

signal skill_pressed(skill)

func unlock_skill(skill: Skill) -> void:
	pass

func _on_attack_button_pressed() -> void:
	attack_pressed.emit()


func _on_strike_button_pressed() -> void:
	skill_pressed.emit("strike")


func _on_slash_button_pressed() -> void:
	skill_pressed.emit("strike")


func _on_regeneration_button_pressed() -> void:
	skill_pressed.emit("strike")


func _on_beyond_button_pressed() -> void:
	skill_pressed.emit("strike")


func _on_end_button_pressed() -> void:
	skill_pressed.emit("strike")
