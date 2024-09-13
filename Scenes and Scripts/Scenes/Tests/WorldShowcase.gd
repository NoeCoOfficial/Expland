@icon("res://Textures/Icons/Script Icons/32x32/world.png")
extends Node3D


func edit_finished():
	get_tree().change_scene_to_file("res://Scenes and Scripts/Scenes/World/world.tscn")


func camera_anim4():
	$Camera3D.position = Vector3(-29.586, 24.865, 24.865)
	$Camera3D.rotation = Vector3(deg_to_rad(7), deg_to_rad(106.9), 0)
	
	var tween = get_tree().create_tween()
	tween.tween_property($Camera3D, "position", Vector3(-29.58, 24.865, 27.852), 7).set_ease(Tween.EASE_IN_OUT)
	await get_tree().create_timer(4).timeout 

	var tweeen = get_tree().create_tween()
	tweeen.tween_property($Camera3D/CanvasLayer/ColorRect, "self_modulate", Color(0, 0, 0, 1), 2)

	tweeen.connect("finished", edit_finished, 1)

func camera_anim3():
	$Camera3D.position = Vector3(-42.77, 25.085, 38.308)
	$Camera3D.rotation = Vector3(deg_to_rad(7), deg_to_rad(-50), 0)
	
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Camera3D, "rotation", Vector3(deg_to_rad(7), deg_to_rad(-77), 0), 5).set_ease(Tween.EASE_IN_OUT)
	tween.connect("finished", camera_anim4, 1)

func camera_anim2():
	$Camera3D.position = Vector3(-37.17, 25.015, 20.709)
	$Camera3D.rotation = Vector3(0, 128.7, 0)
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Camera3D, "position", Vector3(-37.17, 27.737, 20.709), 5).set_ease(Tween.EASE_IN_OUT)
	tween.connect("finished", camera_anim3, 1)
	
	
func camera_anim1():

	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Camera3D, "position", Vector3(-21.80, 26.629, 23.709), 5).set_ease(Tween.EASE_IN_OUT)
	tween.connect("finished", camera_anim2, 1)


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	$AudioStreamPlayer.seek(17.85)
	
	$Camera3D.position = Vector3(-21.80, 26.629, 28.219)
	$Camera3D.rotation = Vector3(0, 127.7, 0)


	await get_tree().create_timer(2).timeout 
	camera_anim1()
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Camera3D/CanvasLayer/ColorRect, "self_modulate", Color(0, 0, 0, 0), 2)

func _input(_event):
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
