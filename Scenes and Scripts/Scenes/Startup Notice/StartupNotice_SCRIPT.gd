# ============================================================= #
# ItemPickupObject_SCRIPT.gd
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

@icon("res://Textures/Icons/Script Icons/32x32/dialogue_start.png")
extends Control

func _ready() -> void:
	if !OS.has_feature("debug"):
		$Notice/DebugNotice.hide()
	
	$Notice/DebugNotice.self_modulate = Color(1, 1, 1, 0)
	$Notice.self_modulate = Color(1, 1, 1, 0)
	
	await get_tree().create_timer(1).timeout
	playTextFade()

func playTextFade():
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Notice, "self_modulate", Color(1, 1, 1, 1), 0.5)
	tween.tween_property($Notice/DebugNotice, "self_modulate", Color(1, 1, 1, 1), 0.5)
	tween.tween_property($Notice, "self_modulate", Color(1, 1, 1, 0), 0.5).set_delay(4)
	tween.tween_property($Notice/DebugNotice, "self_modulate", Color(1, 1, 1, 0), 0.5).set_delay(4)
	tween.connect("finished", Callable(self, "on_fade_finished"))

func on_fade_finished():
	call_deferred("change_to_main_menu")

func change_to_main_menu() -> void:
	get_tree().change_scene_to_file("res://Scenes and Scripts/Scenes/Main Menu/MainMenu.tscn")
