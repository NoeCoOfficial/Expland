# ============================================================= #
# StoryMode_StartCutscene_SCRIPT.gd
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


func _ready() -> void:
	print("ENTERED STORY MODE START CUTSCENE")
	fadeeOutGreyOverlay()
	cutscene_timeline()
	$Camera3D/MainLayer/MinimalDialogue/Text.hide()

func fadeeOutGreyOverlay():
	var tween = get_tree().create_tween()
	tween.connect("finished", onfadeeOutGreyOverlay_Finished)
	tween.tween_property($Camera3D/MainLayer/BlackFade, "modulate", Color(1, 1, 1, 0), 4)

func onfadeeOutGreyOverlay_Finished():
	$Camera3D/MainLayer/BlackFade.visible = false

func cutscene_timeline():
	await get_tree().create_timer(2.5).timeout
	spawnMinimalDialogue(
	3, 
	"Three days out here already... hard to believe it has been so long since I have seen Doc.")

func spawnMinimalDialogue(time : float, msg : String):
	$Camera3D/MainLayer/MinimalDialogue/Text.show()
	$Camera3D/MainLayer/MinimalDialogue/Text.modulate = Color(1, 1, 1, 1)
	$Camera3D/MainLayer/MinimalDialogue/Text.visible_ratio = 0.0
	$Camera3D/MainLayer/MinimalDialogue/Text.text = msg
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Camera3D/MainLayer/MinimalDialogue/Text, "visible_ratio", 1.0, time)
	tween.tween_property($Camera3D/MainLayer/MinimalDialogue/Text, "modulate", Color(1, 1, 1, 0), 1).set_delay(time + 2)
