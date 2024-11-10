@icon("res://Textures/Icons/Script Icons/32x32/main_menu.png")
extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1).timeout
	onStartup()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func fadeOut():
	var tween = get_tree().create_tween()
	tween.tween_property($Camera3D/MainLayer/FadeOut, "modulate", Color(0, 0, 0, 0), 5)

func onStartup():
	fadeOut()
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Camera3D/MainLayer/Logo, "position", Vector2(16, 24), 1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(0.5)
	
	tween.tween_property($Camera3D/MainLayer/PlayButton, "position", Vector2(0, 203), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(1.0)
	tween.tween_property($Camera3D/MainLayer/SettingsButton, "position", Vector2(0, 297), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(1.2)
	tween.tween_property($Camera3D/MainLayer/QuitButton, "position", Vector2(0, 383), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(1.4)

	
