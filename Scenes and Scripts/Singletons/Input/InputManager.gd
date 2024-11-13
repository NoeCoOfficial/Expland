extends Node

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Quit") and OS.has_feature("debug"):
		get_tree().quit()
