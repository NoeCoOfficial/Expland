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

var tap_running : bool = false
var can_toggle_tap : bool = true
var tap_water_fill_tween : Tween

func _ready() -> void:
	Global.is_in_main_menu = false
	$"Yacht Rig/Yacht".position.y = -0.086
	StoryModeManager.is_in_story_mode_first_cutscene_world = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	print("ENTERED STORY MODE START CUTSCENE")
	fadeOutGreyOverlay()
	cutscene_timeline()

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
	$Camera3D/MainLayer/BlackFade.visible = true
	var tween = get_tree().create_tween()
	tween.connect("finished", onfadeInGreyOverlay_Finished)
	tween.tween_property($Camera3D/MainLayer/BlackFade, "modulate", Color(1, 1, 1, 1), 4).from(Color(1, 1, 1, 0))

func onfadeInGreyOverlay_Finished():
	var player_instance = player_scene.instantiate()
	$Camera_Sutle_Movement.stop()
	
	$"Yacht Rig/Yacht".position.y = 0.11
	self.add_child(player_instance)
	$StormTimer.start()
	player_instance.position = Vector3(2.876, -15.188, -16.899)
	player_instance.ResetPOS = Vector3(2.876, -15.188, -16.899)
	player_instance.nodeSetup()
	$Camera3D.clear_current(true)
	$Camera3D/MainLayer/BlackFade.hide()
	new_player_dialogue_timeline()

func new_player_dialogue_timeline():
	await get_tree().create_timer(5.0).timeout
	var dialogues = [
		DialogueManager.StoryMode_StartCutsceneDialogue_2,
		DialogueManager.StoryMode_StartCutsceneDialogue_3,
		DialogueManager.StoryMode_StartCutsceneDialogue_4,
		DialogueManager.StoryMode_StartCutsceneDialogue_5,
	]
	
	var break_times = [27.0, 27.0, 27.0]
	
	var total_duration = 0.0
	for i in range(dialogues.size()):
		var dialogue = dialogues[i]
		# Schedule the dialogue to be played after the total_duration
		get_tree().create_timer(total_duration).connect("timeout", Callable(self, "_play_dialogue").bind(dialogue))
		# Calculate the duration of the current dialogue
		var dialogue_duration = 0.0
		for message in dialogue:
			dialogue_duration += message["time"]
		# Add the dialogue duration to the total duration
		total_duration += dialogue_duration
		# Add the break time to the total duration if it's not the last dialogue
		if i < break_times.size():
			total_duration += break_times[i]

func _play_dialogue(dialogue):
	MD.spawnMinimalDialogue(dialogue)

#####################################

func cutscene_timeline():
	await get_tree().create_timer(3).timeout
	MD.spawnMinimalDialogue(DialogueManager.StoryMode_StartCutsceneDialogue_1)
	
	# Assuming fadeInGreyOverlay should be called after the last dialogue
	var total_duration = 2 + 6 * (DialogueManager.StoryMode_StartCutsceneDialogue_1.size() - 1) + DialogueManager.StoryMode_StartCutsceneDialogue_1[-1]["time"]
	get_tree().create_timer(total_duration).connect("timeout", fadeInGreyOverlay)


func _on_red_lever_triggered() -> void:
	$"Yacht Rig/Yacht/RedLever".toggle_lever(!$"Yacht Rig/Yacht/RedLever".state_on)

func _on_green_lever_triggered() -> void:
	$"Yacht Rig/Yacht/BlueLever".toggle_lever(!$"Yacht Rig/Yacht/BlueLever".state_on)

func _on_blue_lever_triggered() -> void:
	$"Yacht Rig/Yacht/GreenLever".toggle_lever(!$"Yacht Rig/Yacht/GreenLever".state_on)


func _on_tap_toggled() -> void:
	if can_toggle_tap:
		can_toggle_tap = false
		$"Yacht Rig/Yacht/Tap Cooldown".start()
		
		tap_running = !tap_running
		
		if tap_running:
			$"Yacht Rig/Yacht/Interactable Component/Contents/UI/SubViewport/MessageWithKeyUI_1/Contents/Message".text = "Turn off"
			if tap_water_fill_tween:
				tap_water_fill_tween.kill()
			tap_water_fill_tween = get_tree().create_tween().set_parallel()
			tap_water_fill_tween.tween_property(
				$"Yacht Rig/Yacht/TapWaterFillMesh", 
				"position:y", 
				1.249, 
				20)
			
			tap_water_fill_tween.tween_property(
				$"Yacht Rig/Yacht/TapWaterMesh", 
				"position:y", 
				1.337, 
				0.3)
			
			tap_water_fill_tween.tween_property(
				$"Yacht Rig/Yacht/TapWaterMesh", 
				"scale:y", 
				0.459, 
				0.3)
		else:
			$"Yacht Rig/Yacht/Interactable Component/Contents/UI/SubViewport/MessageWithKeyUI_1/Contents/Message".text = "Turn on"
			if tap_water_fill_tween:
				tap_water_fill_tween.kill()
			tap_water_fill_tween = get_tree().create_tween().set_parallel()
			tap_water_fill_tween.tween_property(
				$"Yacht Rig/Yacht/TapWaterFillMesh", 
				"position:y", 
				1.172, 
				10)
			
			tap_water_fill_tween.tween_property(
				$"Yacht Rig/Yacht/TapWaterMesh", 
				"position:y", 
				1.117, 
				0.3)
				
			tap_water_fill_tween.tween_property(
				$"Yacht Rig/Yacht/TapWaterMesh", 
				"position:y", 
				1.562, 
				0.0).set_delay(0.3)
			
			tap_water_fill_tween.tween_property(
				$"Yacht Rig/Yacht/TapWaterMesh", 
				"scale:y", 
				0.024, 
				0.3)

func _on_tap_cooldown_timeout() -> void:
	can_toggle_tap = true


func _on_storm_timer() -> void:
	print("STARTING STORM")
