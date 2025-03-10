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

@onready var MD : Control = $Camera3D/MainLayer/MinimalDialogue
@onready var player_scene = preload("uid://cjm5lrxicdgsf")


func _ready() -> void:
	print("ENTERED STORY MODE START CUTSCENE")
	fadeOutGreyOverlay()
	cutscene_timeline()
	$Camera3D/MainLayer/MinimalDialogue/Text.hide()

#####################################

func fadeOutGreyOverlay():
	var tween = get_tree().create_tween()
	tween.connect("finished", onfadeOutGreyOverlay_Finished)
	tween.tween_property($Camera3D/MainLayer/BlackFade, "modulate", Color(1, 1, 1, 0), 4)

func onfadeOutGreyOverlay_Finished():
	$Camera3D/MainLayer/BlackFade.visible = false

#####################################
#####################################

func fadeInGreyOverlay():
	#$Camera3D/MainLayer/BlackFade.visible = true
	var tween = get_tree().create_tween()
	tween.connect("finished", onfadeInGreyOverlay_Finished)
	tween.tween_property($Camera3D/MainLayer/BlackFade, "modulate", Color(1, 1, 1, 1), 4).from(Color(1, 1, 1, 0))

func onfadeInGreyOverlay_Finished():
	var player_instance = player_scene.instantiate()
	$Camera_Sutle_Movement.stop()
	$"Yacht Bob".stop()
	player_instance.StartPOS = Vector3(2.07, -15.328, -17.33)

#####################################

func cutscene_timeline():
	await get_tree().create_timer(2).timeout
	print("Dialogue 1")
	MD.spawnMinimalDialogue(
	2.5, 
	'"Three days out here already... hard to believe it has been so long since I have seen Doc."')
	
	await get_tree().create_timer(6).timeout
	print("Dialogue 2")
	MD.spawnMinimalDialogue(
	2.5, 
	'"Just me and the waves and the smell of the sea, huh? Could get used to this, but I better not."')
	
	await get_tree().create_timer(6).timeout
	print("Dialogue 3")
	MD.spawnMinimalDialogue(
	2.5, 
	'"This trip is only the beginning of something much bigger. Bigger?"')
	
	await get_tree().create_timer(6).timeout
	fadeInGreyOverlay()
	
