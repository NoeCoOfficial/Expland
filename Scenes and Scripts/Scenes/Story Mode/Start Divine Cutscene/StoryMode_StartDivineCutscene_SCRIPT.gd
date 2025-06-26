# ============================================================= #
# StoryMode_StartDivineCutscene_SCRIPT.gd
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

extends Control

func _ready() -> void:
	start_divine_cutscene()
	IslandManager.Current_Game_Mode = "STORY"

func nodes_init():
	$FadeIn_White.color = Color(0, 0, 0, 1)
	$"Tinnitus Effect".volume_db = -60


func start_divine_cutscene():
	nodes_init()
	
	$"Tinnitus Effect".play()
	
	var divine_cutscene_tween_start = get_tree().create_tween().set_parallel()
	divine_cutscene_tween_start.connect("finished", _on_first_tween_finished)
	divine_cutscene_tween_start.tween_property($FadeIn_White, "color", Color(1, 1, 1, 1), 4.0)
	divine_cutscene_tween_start.tween_property($"Tinnitus Effect", "volume_db", -5.695, 3.0)
	
	
	divine_cutscene_tween_start.tween_property($TextAndStuff/snapoutofit, "visible", true, 0.0).set_delay(4.0)
	divine_cutscene_tween_start.tween_property($TextAndStuff/snapoutofit, "visible", false, 0.0).set_delay(7.0)
	
	divine_cutscene_tween_start.tween_interval(2.0)

func _on_first_tween_finished():
	$Music.play()

	var divine_cutscene_tween_next = get_tree().create_tween().set_parallel()
	divine_cutscene_tween_next.connect("finished", end)
	divine_cutscene_tween_next.tween_property($TextAndStuff/whyudie, "visible", true, 0.0).set_delay(4.0)
	
	divine_cutscene_tween_next.tween_property($TextAndStuff/whyudie, "visible", false, 0.0).set_delay(7.0)
	divine_cutscene_tween_next.tween_property($TextAndStuff/opportunities, "visible", true, 0.0).set_delay(7.0)
	
	divine_cutscene_tween_next.tween_property($TextAndStuff/opportunities, "visible", false, 0.0).set_delay(11.0)
	divine_cutscene_tween_next.tween_property($TextAndStuff/seizednone, "visible", true, 0.0).set_delay(11.0)
	
	divine_cutscene_tween_next.tween_property($TextAndStuff/seizednone, "visible", false, 0.0).set_delay(14.0)
	
	divine_cutscene_tween_next.tween_property($TextAndStuff/anotherchance, "visible", true, 0.0).set_delay(18.0)
	divine_cutscene_tween_next.tween_property($TextAndStuff/anotherchance, "visible", false, 0.0).set_delay(22.0)
	
	divine_cutscene_tween_next.tween_property($TextAndStuff/useitwisely, "visible", true, 0.0).set_delay(25.0)
	divine_cutscene_tween_next.tween_property($TextAndStuff/useitwisely, "visible", false, 0.0).set_delay(29.0)
	
	divine_cutscene_tween_next.tween_property($FadeOut_Black, "modulate", Color(1, 1, 1, 1), 4.0).set_delay(32.0)
	divine_cutscene_tween_next.tween_property($"Tinnitus Effect", "volume_db", -60, 5.0).set_delay(32.0)
	divine_cutscene_tween_next.tween_property($Music, "volume_db", -60, 5.0).set_delay(32.0)

func end():
	print("END DIVINE CUTSCENE")
	get_tree().change_scene_to_file("uid://c5jkrckgqd0w6")
