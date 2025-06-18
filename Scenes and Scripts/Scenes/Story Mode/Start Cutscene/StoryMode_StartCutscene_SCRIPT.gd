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

@export var MD : Control
@export var PlayerSpawnPos : Node3D
@export var BlackFade : Control
@export var StormTimer : Timer
@export var Tap_Cooldown : Timer
@export var TapInteractMessageLabel : Label
@export var Camera_Sutle_Movement_Animation : AnimationPlayer
@export var TapWaterMesh : MeshInstance3D
@export var TapWaterFillMesh : MeshInstance3D
@export var RedLever : Node3D
@export var GreenLever : Node3D
@export var BlueLever : Node3D
@export var Default_Camera : Camera3D

@onready var player_scene = preload("uid://cjm5lrxicdgsf")

var tap_running : bool = false
var can_toggle_tap : bool = true
var tap_water_fill_tween : Tween
var player : CharacterBody3D

func _ready() -> void:
	$"Yacht Rig/Yacht/FallOffCameraRig/Fall Off Cutscene Camera".fov = PlayerSettingsData.FOV
	$Camera3D.fov = PlayerSettingsData.FOV
	Global.is_in_main_menu = false
	StoryModeManager.is_in_story_mode_first_cutscene_world = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	print("ENTERED STORY MODE START CUTSCENE")
	await get_tree().create_timer(2.0).timeout
	$WindAmbience.play()
	fadeOutGreyOverlay()
	cutscene_timeline()

#####################################

func fadeOutGreyOverlay():
	var tween = get_tree().create_tween()
	tween.connect("finished", onfadeOutGreyOverlay_Finished)
	tween.tween_property(BlackFade, "modulate", Color(1, 1, 1, 0), 4)

func onfadeOutGreyOverlay_Finished():
	BlackFade.visible = false

#####################################
#####################################

func fadeInGreyOverlay():
	BlackFade.visible = true
	var tween = get_tree().create_tween()
	tween.connect("finished", onfadeInGreyOverlay_Finished)
	tween.tween_property(BlackFade, "modulate", Color(1, 1, 1, 1), 4).from(Color(1, 1, 1, 0))

func onfadeInGreyOverlay_Finished():
	var player_instance = player_scene.instantiate()
	player = player_instance
	Camera_Sutle_Movement_Animation.stop()
	
	self.add_child(player_instance)
	StormTimer.start()
	player_instance.global_position = PlayerSpawnPos.global_position
	player_instance.ResetPOS = PlayerSpawnPos.global_position
	player_instance.nodeSetup()
	Default_Camera.clear_current(true)
	BlackFade.hide()
	$WaterMesh.hide()
	$"WaterMesh(INBOAT)".show()
	player_instance.camera.make_current()
	new_player_dialogue_timeline()

func new_player_dialogue_timeline():
	await get_tree().create_timer(5.0).timeout
	var dialogues = [
		DialogueManager.StoryMode_StartCutscene_Dialogue_4,
		DialogueManager.StoryMode_StartCutscene_Dialogue_5,
		DialogueManager.StoryMode_StartCutscene_Dialogue_6,
		DialogueManager.StoryMode_StartCutscene_Dialogue_7,
		DialogueManager.StoryMode_StartCutscene_Dialogue_8,
	]
	
	var break_times = [27.0, 27.0, 27.0, 27.0]
	
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
	MD.spawnMinimalDialogue(DialogueManager.StoryMode_StartCutscene_Dialogue_3)
	
	# Assuming fadeInGreyOverlay should be called after the last dialogue
	var total_duration = 2 + 6 * (DialogueManager.StoryMode_StartCutscene_Dialogue_3.size() - 1) + DialogueManager.StoryMode_StartCutscene_Dialogue_3[-1]["time"]
	get_tree().create_timer(total_duration).connect("timeout", fadeInGreyOverlay)


func _on_red_lever_triggered() -> void:
	RedLever.toggle_lever(!RedLever.state_on)

func _on_green_lever_triggered() -> void:
	GreenLever.toggle_lever(!GreenLever.state_on)

func _on_blue_lever_triggered() -> void:
	BlueLever.toggle_lever(!BlueLever.state_on)


func _on_tap_toggled() -> void:
	if can_toggle_tap:
		can_toggle_tap = false
		Tap_Cooldown.start()
		
		tap_running = !tap_running
		
		if tap_running:
			TapInteractMessageLabel.text = "Turn off"
			if tap_water_fill_tween:
				tap_water_fill_tween.kill()
			tap_water_fill_tween = get_tree().create_tween().set_parallel()
			tap_water_fill_tween.tween_property(
				TapWaterFillMesh, 
				"position:y", 
				1.249, 
				20)
			
			tap_water_fill_tween.tween_property(
				TapWaterMesh, 
				"position:y", 
				1.337, 
				0.3)
			
			tap_water_fill_tween.tween_property(
				TapWaterMesh, 
				"scale:y", 
				0.459, 
				0.3)
		else:
			TapInteractMessageLabel.text = "Turn on"
			if tap_water_fill_tween:
				tap_water_fill_tween.kill()
			tap_water_fill_tween = get_tree().create_tween().set_parallel()
			tap_water_fill_tween.tween_property(
				TapWaterFillMesh, 
				"position:y", 
				1.172, 
				10)
			
			tap_water_fill_tween.tween_property(
				TapWaterMesh, 
				"position:y", 
				1.117, 
				0.3)
				
			tap_water_fill_tween.tween_property(
				TapWaterMesh, 
				"position:y", 
				1.562, 
				0.0).set_delay(0.3)
			
			tap_water_fill_tween.tween_property(
				TapWaterMesh, 
				"scale:y", 
				0.024, 
				0.3)

func _on_tap_cooldown_timeout() -> void:
	can_toggle_tap = true

func playBlinkEffect():
	$EyeBlinkLayer/BlinkAnimation.play("main")

func _on_storm_timer() -> void:
	
	$"Falling Off Boat Cutscene".play("main")

func setPlayerVisibility(value : bool):
	player.visible = value

func goToIsland():
	get_tree().change_scene_to_file("uid://c5jkrckgqd0w6")
