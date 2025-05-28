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

func _ready() -> void:
	
	$Player.hide()
	$"PreControl Scene/EyeBlinkLayer/BottomBlink".position = Vector2(0.0, 688.0)
	$"PreControl Scene/EyeBlinkLayer/TopBlink".position = Vector2(1152.0, -39.0)
	$"PreControl Scene/Camera3D".fov = PlayerSettingsData.FOV
	StoryModeManager.is_in_cutscene = true
	$Player.nodeSetup()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("DebugAction1"):
		TheEryv.start_chase_player()
		$EryvPathUpdater.start()

func init_player_control():
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
		global_position = Vector3(x, y, 0) + original_position
		await get_tree().process_frame
	
	camera.global_position = original_position
	
