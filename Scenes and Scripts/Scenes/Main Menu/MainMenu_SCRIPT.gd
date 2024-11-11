@icon("res://Textures/Icons/Script Icons/32x32/main_menu.png")
extends Node3D

@onready var DefaultXPos_PlayButton = $Camera3D/MainLayer/PlayButton.position.x

######################################
# Startup
######################################

func _ready() -> void:
	Utils.set_center_offset($Camera3D/MainLayer/PlayButton)
	Utils.set_center_offset($Camera3D/MainLayer/PlayButtonTrigger)
	
	Utils.set_center_offset($Camera3D/MainLayer/SettingsButton)
	Utils.set_center_offset($Camera3D/MainLayer/QuitButton)

	await get_tree().create_timer(1).timeout
	onStartup()

func fadeOut():
	var tween = get_tree().create_tween()
	tween.tween_property($Camera3D/MainLayer/FadeOut, "modulate", Color(0, 0, 0, 0), 5)

func onStartup():
	fadeOut()
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Camera3D/MainLayer/Logo, "position:x", -15, 1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(0.5)
	
	tween.tween_property($Camera3D/MainLayer/PlayButton, "position", Vector2(0, 203), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(1.0)
	tween.tween_property($Camera3D/MainLayer/PlayButtonTrigger, "position", Vector2(0, 203), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(1.0)

	tween.tween_property($Camera3D/MainLayer/SettingsButton, "position", Vector2(0, 297), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(1.2)
	tween.tween_property($Camera3D/MainLayer/QuitButton, "position", Vector2(0, 383), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(1.4)

######################################
# PlayButton animations and functions
######################################

func _on_play_button_trigger_mouse_entered() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Camera3D/MainLayer/PlayButtonTrigger, "position:x", 20.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Camera3D/MainLayer/PlayButton, "position:x", 20.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_play_button_trigger_mouse_exited() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Camera3D/MainLayer/PlayButtonTrigger, "position:x", 0.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Camera3D/MainLayer/PlayButton, "position:x", 0.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)


func _on_play_button_trigger_button_down() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Camera3D/MainLayer/PlayButtonTrigger, "scale", Vector2(1.05, 1.05), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Camera3D/MainLayer/PlayButton, "scale", Vector2(1.05, 1.05), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_play_button_trigger_button_up() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Camera3D/MainLayer/PlayButtonTrigger, "scale", Vector2(1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Camera3D/MainLayer/PlayButton, "scale", Vector2(1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_play_button_trigger_pressed() -> void:
	print("{LOCAL} [MainMenu_SCRIPT.gd] Play button pressed.")

######################################
# SettingsButton animations and functions
######################################

func _on_settings_button_trigger_mouse_entered() -> void:
	pass # Replace with function body.

func _on_settings_button_trigger_mouse_exited() -> void:
	pass # Replace with function body.

func _on_settings_button_trigger_button_up() -> void:
	pass # Replace with function body.

func _on_settings_button_trigger_button_down() -> void:
	pass # Replace with function body.

func _on_settings_button_trigger_pressed() -> void:
	print("{LOCAL} [MainMenu_SCRIPT.gd] Settings button pressed.")

######################################
# QuitButton animations and functions
######################################

func _on_quit_button_trigger_button_up() -> void:
	pass # Replace with function body.

func _on_quit_button_trigger_button_down() -> void:
	pass # Replace with function body.

func _on_quit_button_trigger_mouse_entered() -> void:
	pass # Replace with function body.

func _on_quit_button_trigger_mouse_exited() -> void:
	pass # Replace with function body.

func _on_quit_button_trigger_pressed() -> void:
	print("{LOCAL} [MainMenu_SCRIPT.gd] Quit button pressed.")
