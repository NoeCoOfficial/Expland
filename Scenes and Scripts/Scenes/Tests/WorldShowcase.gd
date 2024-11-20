# ============================================================= #
# WorldShowcase.gd
# ============================================================= #
#                       COPYRIGHT NOTICE                        #
#                           Noe Co.                             #
#            (2024 - Present) - All Rights Reserved             #
#                                                               #
#                     Noe Co. Game License                      #
#                                                               #
# Permission is hereby granted to any person to view, fork,     #
# and make personal modifications to this software (the         #
# "Software"), solely for private, non-commercial use.          #
#                                                               #
# Restrictions:                                                 #
# 1. You may NOT distribute, publish, or make publicly          #
#    available any part of the original or modified Software.   #
# 2. You may NOT share, host, or release modified versions,     #
#    including derivative works, in any public or commercial    #
#    form.                                                      #
# 3. You may NOT use the Software for commercial purposes       #
#    without prior written permission from Noe Co.              #
#                                                               #
# Ownership:                                                    #
# Noe Co. retains all rights, title, and interest in and to     #
# the Software and associated intellectual property. This       #
# license does not grant ownership of the Software.             #
#                                                               #
# Termination:                                                  #
# This license is effective as of your initial access and       #
# remains until terminated. Breach of any term results in       #
# automatic termination, requiring destruction of all copies.   #
#                                                               #
# Disclaimer of Warranty:                                       #
# THE SOFTWARE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY      #
# KIND. NOE CO. DISCLAIMS ALL WARRANTIES, WHETHER EXPRESS,      #
# IMPLIED, OR STATUTORY, INCLUDING WARRANTIES OF                #
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.          #
#                                                               #
# Limitation of Liability:                                      #
# NOE CO. SHALL NOT BE LIABLE FOR ANY DAMAGES ARISING FROM      #
# USE OR INABILITY TO USE THE SOFTWARE, INCLUDING INDIRECT,     #
# INCIDENTAL, OR CONSEQUENTIAL DAMAGES.                         #
#                                                               #
#                   For inquiries, contact:                     #
#                  noeco.official@gmail.com                     #
# ============================================================= #

@icon("res://Textures/Icons/Script Icons/32x32/world.png")
extends Node3D


func edit_finished():
	get_tree().change_scene_to_file("res://Scenes and Scripts/Scenes/The Island/TheIsland.tscn")


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
