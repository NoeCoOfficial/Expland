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
	var tween = get_tree().create_tween()
	tween.tween_property($Camera3D/MainLayer/Logo, "position", Vector2(16, 24), 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(1)

	
	
