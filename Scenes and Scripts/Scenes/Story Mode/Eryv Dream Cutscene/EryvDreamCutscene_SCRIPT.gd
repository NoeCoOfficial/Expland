# ============================================================= #
# EryvDreamCutscene_SCRIPT.gd
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

extends Node3D

@export var TheEryv : CharacterBody3D
var scene_thread : Thread

func _ready() -> void:
	scene_thread = Thread.new()
	var ambient_fade_in = get_tree().create_tween()
	ambient_fade_in.tween_property($Environment/AmbientWindLoop, "volume_db", 5.0, 1).from(-10.0)
	$Environment/AmbientWindLoop.play()
	$Player.hide()
	$Player/Head/Camera3D/HUDLayer.hide()
	$"PreControl Scene/EyeBlinkLayer/BottomBlink".position = Vector2(0.0, 688.0)
	$"PreControl Scene/EyeBlinkLayer/TopBlink".position = Vector2(1152.0, -39.0)
	$"PreControl Scene/Camera3D".fov = PlayerSettingsData.FOV
	StoryModeManager.is_in_cutscene = true
	$Player.Fade_In = false
	$Player.nodeSetup()
	
	
	$"PreControl Scene/CameraMotion".play("motion")

func eryv_start_chase_player():
	TheEryv.start_chase_player()
	$EryvPathUpdater.start()

func init_player_control():
	$Player.show()
	$Player/Head/Camera3D/HUDLayer.show()
	$"PreControl Scene/Camera3D".clear_current(true)
	StoryModeManager.is_in_cutscene = false
	StoryModeManager.is_in_cutscene_can_move = true

func _on_eryv_path_updater_timeout() -> void:
	TheEryv.update_chase_player()

func playBlinkEffect():
	$"PreControl Scene/EyeBlinkLayer/BlinkAnimation".play("main")

func shake_camera(camera : Camera3D, duration : float, strength : float):
	var original_position : Vector3 = camera.global_position
	var shake_start_time: float = Time.get_ticks_msec() / 1000.0 # convert to seconds
	
	while (Time.get_ticks_msec() / 1000.0) - shake_start_time < duration:
		var x : float = randf_range(-strength,  strength)
		var y : float = randf_range(-strength,  strength)
		camera.global_position = Vector3(x, y, 0) + original_position
		await get_tree().process_frame
	
	camera.global_position = original_position

func camera_motion_shake():
	shake_camera($"PreControl Scene/Camera3D", 2.0, 0.08)

func play_eryv_feugcs():
	$"The Eryv/Fuegcs1".play()


#################################################

func _on_player_wake_up_area_area_entered(area: Area3D) -> void:
	if area.is_in_group(&"PlayerArea"):
		WAKE_UP()

func WAKE_UP():
	print("WAKE UP")
	StoryModeManager.waking_up_from_eryv_dream = true
	StoryModeManager.is_in_cutscene_can_move = false
	PlayerData.STORY_MODE_PROGRESSION_INFO["FIRST_STORY_MODE"] = false
	
	$Player/Head/Camera3D/TopLayer/BlackThing.show()
	$Environment/AmbientWindLoop.stop()
	
	$SceneChangeDebounce.start()


func _on_scene_change_debounce_timeout() -> void:
	get_tree().change_scene_to_packed(load("uid://c5jkrckgqd0w6"))
