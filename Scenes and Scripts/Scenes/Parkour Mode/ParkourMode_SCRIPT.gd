# ============================================================= #
# ParkourMode_SCRIPT.gd
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

@export var Player : CharacterBody3D

func _ready():
	Player.nodeSetup()
	Player.disableHunger()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("PlayerBody"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		StoryModeManager.is_in_cutscene = true
		$CanvasLayers/EndScreen/EndScreenAnimation.play("main")


func _on_main_menu_button_pressed() -> void:
	$CanvasLayers/TopLayer/BlackOverlay.modulate = Color(1, 1, 1, 0)
	$CanvasLayers/TopLayer/BlackOverlay.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($CanvasLayers/TopLayer/BlackOverlay, "modulate", Color(1, 1, 1, 1), 1.0)
	tween.connect("finished", _end_screen_fade_out_finished)


func _end_screen_fade_out_finished() -> void:
	StoryModeManager.is_in_cutscene = false
	get_tree().change_scene_to_file("uid://234mnfypwndn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_restart_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	StoryModeManager.is_in_cutscene = false
	$CanvasLayers/EndScreen/Content.hide()
	$CanvasLayers/EndScreen/BlackScreen.hide()
	Player.position = Player.ResetPOS

func _on_view_authorsmd_button_pressed() -> void:
	OS.shell_open("https://github.com/NoeCoOfficial/Expland/blob/main/AUTHORS.md")

func _on_join_discord_server_button_pressed() -> void:
	OS.shell_open("https://discord.gg/QNgcKCAJn3")


func _on_respawn_box_body_entered(body: Node3D) -> void:
	if body.is_in_group(&"PlayerBody"):
		Player.global_position = Vector3(-0.11, 0.957, 2.595)
