extends Control

signal attack_pressed()


func _on_attack_button_pressed() -> void:
	attack_pressed.emit()

func _on_skills_button_pressed() -> void:
	pass # Replace with function body.
