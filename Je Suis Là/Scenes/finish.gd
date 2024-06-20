extends Control

signal restart

func _on_choice_button_button_up():
	restart.emit()
	queue_free()
	pass # Replace with function body.
