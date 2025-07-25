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
@export var finished_look_around_dream_cutscene : bool = false
@export var eryv_chasing_player : bool = false

func _ready() -> void:
	# When we get back to The Island,
	# Time will by 10 am (600/60)
	TimeManager.CURRENT_TIME = 600
	PlayerData.GAME_STATE = "NORMAL"
	
	
	var ambient_fade_in = get_tree().create_tween()
	ambient_fade_in.tween_property($Environment/AmbientWindLoop, "volume_db", 5.0, 1).from(-10.0)
	$Environment/AmbientWindLoop.play()
	$Player.hide()
	$Player/Head/Camera3D/HUDLayer.hide()
	$"PreControl Scene/EyeBlinkLayer/BottomBlink".position = Vector2(0.0, 688.0)
	$"PreControl Scene/EyeBlinkLayer/TopBlink".position = Vector2(1152.0, -39.0)
	$"PreControl Scene/Camera3DRig/Camera3D".fov = PlayerSettingsData.FOV
	StoryModeManager.is_in_cutscene = true
	$Player.Fade_In = false
	$Player.nodeSetup()
	
	$"PreControl Scene/CameraMotion".play("motion")

func _input(event: InputEvent) -> void:
	if !eryv_chasing_player:
		if finished_look_around_dream_cutscene:
			if Input.is_action_just_pressed("Jump") or Input.is_action_just_pressed("move_forward") or Input.is_action_just_pressed("move_backward") or Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
				eryv_start_chase_player()

func spawn_run_minimal_dialogue():
	$Player/Head/Camera3D/MinimalDialogueLayer/MinimalDialogue.spawnMinimalDialogue(DialogueManager.StoryMode_EryvDream_Dialogue)

func eryv_start_chase_player():
	eryv_chasing_player = true
	TheEryv.start_chase_player()
	$EryvPathUpdater.start()
	$"The Eryv/Stomps".play()
	$"The Eryv/StompTimer".start()
	
	# Start fuegcs interval timer
	$EryvFuegcsInterval.start()

func init_player_control():
	$Player.show()
	$Player/Head/Camera3D/HUDLayer.show()
	$"PreControl Scene/Camera3DRig/Camera3D".clear_current(true)
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
	shake_camera($"PreControl Scene/Camera3DRig/Camera3D", 2.0, 0.08)

func play_eryv_feugcs():
	$"The Eryv/Fuegcs1".play()

#################################################

func _on_player_wake_up_area_area_entered(area: Area3D) -> void:
	if area.is_in_group(&"PlayerArea"):
		WAKE_UP()

func WAKE_UP():
	print("WAKE UP")
	TimeManager.speedrun_timer_stop()
	StoryModeManager.waking_up_from_eryv_dream = true
	StoryModeManager.is_in_cutscene_can_move = false
	StoryModeManager.is_in_cutscene = true
	PlayerData.STORY_MODE_PROGRESSION_INFO["FIRST_STORY_MODE"] = false
	
	$Player/Head/Camera3D/TopLayer/BlackThing.show()
	$"The Eryv/Stomps".volume_db = -80.0
	$Environment/AmbientWindLoop.stop()
	
	$SceneChangeDebounce.start()


func _on_scene_change_debounce_timeout() -> void:
	get_tree().change_scene_to_packed(load("uid://c5jkrckgqd0w6"))


func _on_stomp_timer_timeout() -> void:
	$"The Eryv/Stomps".play()
	$"The Eryv/StompTimer".start()


func _on_eryv_fuegcs_interval_timeout() -> void:
	shake_camera($"PreControl Scene/Camera3DRig/Camera3D", 2.0, 0.08)
	$"The Eryv/RandomFuegcs".play()
