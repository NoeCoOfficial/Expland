# ============================================================= #
# MainMenu_SCRIPT.gd
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

@icon("res://Textures/Icons/Script Icons/32x32/main_menu.png")
extends Node3D

var transitioning_scene = false
var is_in_gamemode_select = false

@onready var StartupNotice = preload("res://Scenes and Scripts/Scenes/Startup Notice/StartupNotice.tscn")
@onready var world = preload("res://Scenes and Scripts/Scenes/The Island/TheIsland.tscn")
@onready var DefaultXPos = $Camera3D/MainLayer/PlayButton.position.x

######################################
# Startup
######################################

func _ready() -> void:
	PauseManager.is_paused = false
	if Global.is_first_time_in_menu:
		Global.is_first_time_in_menu = false
		
		if PlayerSettingsData.showStartupScreen == true:
			call_deferred("change_to_startup_notice")
	
	$Camera3D/MainLayer/GreyLayerGamemodeLayer.hide()
	$Camera3D/MainLayer/GreyLayerGamemodeLayer.modulate = Color(1, 1, 1, 0)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	PlayerSettingsData.loadSettings()
	
	Utils.set_center_offset($Camera3D/MainLayer/PlayButton)
	Utils.set_center_offset($Camera3D/MainLayer/PlayButtonTrigger)
	
	Utils.set_center_offset($Camera3D/MainLayer/SettingsButton)
	Utils.set_center_offset($Camera3D/MainLayer/SettingsButtonTrigger)
	
	Utils.set_center_offset($Camera3D/MainLayer/QuitButton)
	Utils.set_center_offset($Camera3D/MainLayer/QuitButtonTrigger)

	
	await get_tree().create_timer(1).timeout
	onStartup()

	await get_tree().create_timer(2).timeout
	$Camera3D/MainLayer/ProtectiveLayer.visible = false

func change_to_startup_notice() -> void:
	get_tree().change_scene_to_packed(StartupNotice)

func fadeOut(node):
	var tween = get_tree().create_tween()
	tween.tween_property(node, "modulate", Color(0, 0, 0, 0), 5)

func onStartup():
	fadeOut($Camera3D/MainLayer/FadeOut)
	$Camera3D/MainLayer/Version_LBL.visible = true
	
	var tween = get_tree().create_tween().set_parallel()
	
	tween.tween_property($Camera3D/MainLayer/Logo, "position:x", -15, 1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(0.5)
	
	tween.tween_property($Camera3D/MainLayer/PlayButton, "position", Vector2(0, 203), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(1.0)
	tween.tween_property($Camera3D/MainLayer/PlayButtonTrigger, "position", Vector2(0, 203), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(1.0)
	
	tween.tween_property($Camera3D/MainLayer/SettingsButton, "position", Vector2(0, 297), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(1.2)
	tween.tween_property($Camera3D/MainLayer/SettingsButtonTrigger, "position", Vector2(0, 297), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(1.2)
	
	tween.tween_property($Camera3D/MainLayer/QuitButton, "position", Vector2(0, 383), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(1.4)
	tween.tween_property($Camera3D/MainLayer/QuitButtonTrigger, "position", Vector2(0, 383), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(1.4)
	
	tween.tween_property($Camera3D/MainLayer/AchievementsButton, "position", Vector2(947, 558), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(1.2)
	
	tween.tween_property($Camera3D/MainLayer/CreditsButton, "position", Vector2(1018, 605), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(1.2)


######################################
# Input
######################################

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Exit"):
		if is_in_gamemode_select:
			deSpawnGameModeMenu()
		if PauseManager.is_inside_settings:
			$Camera3D/MainLayer/SettingsUI.closeSettings(0.5)
		if PauseManager.is_inside_achievements_ui:
			$Camera3D/MainLayer/AchievementsUI.despawnAchievements(0.5)
		if PauseManager.is_inside_credits:
			$Camera3D/MainLayer/CreditsLayer.despawnCredits(0.5)

######################################
# PlayButton animations and functions
######################################

func _on_play_button_trigger_mouse_entered() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Camera3D/MainLayer/PlayButtonTrigger, "position:x", 20.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Camera3D/MainLayer/PlayButton, "position:x", 20.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_play_button_trigger_mouse_exited() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Camera3D/MainLayer/PlayButtonTrigger, "position:x", 0.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Camera3D/MainLayer/PlayButton, "position:x", 0.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_play_button_trigger_button_down() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Camera3D/MainLayer/PlayButtonTrigger, "scale", Vector2(1.05, 1.05), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Camera3D/MainLayer/PlayButton, "scale", Vector2(1.05, 1.05), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_play_button_trigger_button_up() -> void:
	if !transitioning_scene:
		var tween = get_tree().create_tween().set_parallel()
		tween.tween_property($Camera3D/MainLayer/PlayButtonTrigger, "scale", Vector2(1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		tween.tween_property($Camera3D/MainLayer/PlayButton, "scale", Vector2(1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_play_button_trigger_pressed() -> void:
	spawnGameModeMenu()

func spawnGameModeMenu():
	
	$Camera3D/MainLayer/PlayButtonTrigger.visible = false
	$Camera3D/MainLayer/GreyLayerGamemodeLayer.show()
	
	var tween = get_tree().create_tween().set_parallel()
	tween.connect("finished", Callable(self, "on_spawn_game_mode_menu_tween_finished"))
	
	tween.tween_property($Camera3D/MainLayer/GreyLayerGamemodeLayer, "modulate", Color(1, 1, 1, 1), 0.5)
	
	tween.tween_property($Camera3D/MainLayer/ExitGamemodeLayerButton, "position", Vector2(15, 11), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

	tween.tween_property($Camera3D/MainLayer/GameModeLayer/BG_StoryMode, "position:y", -580, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Camera3D/MainLayer/GameModeLayer/BG_FreeMode, "position:y", -580, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(0.1)
	tween.tween_property($Camera3D/MainLayer/GameModeLayer/BG_ParkourMode, "position:y", -580, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(0.2)

func on_spawn_game_mode_menu_tween_finished():
	is_in_gamemode_select = true


func deSpawnGameModeMenu():
	if !transitioning_scene:
		is_in_gamemode_select = false
		
		$Camera3D/MainLayer/PlayButtonTrigger.visible = true
		
		var tween = get_tree().create_tween().set_parallel()
		
		tween.tween_property($Camera3D/MainLayer/GreyLayerGamemodeLayer, "modulate", Color(1, 1, 1, 0), 1)
		tween.tween_property($Camera3D/MainLayer/GreyLayerGamemodeLayer, "visible", false, 0).set_delay(1)
		
		tween.tween_property($Camera3D/MainLayer/ExitGamemodeLayerButton, "position", Vector2(15, -54), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
		
		tween.tween_property($Camera3D/MainLayer/GameModeLayer/BG_StoryMode, "position:y", 28, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
		tween.tween_property($Camera3D/MainLayer/GameModeLayer/BG_FreeMode, "position:y", 28, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO).set_delay(0.1)
		tween.tween_property($Camera3D/MainLayer/GameModeLayer/BG_ParkourMode, "position:y", 28, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO).set_delay(0.2)

######################################
# SettingsButton animations and functions
######################################

func _on_settings_button_trigger_mouse_entered() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Camera3D/MainLayer/SettingsButtonTrigger, "position:x", 20.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Camera3D/MainLayer/SettingsButton, "position:x", 20.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_settings_button_trigger_mouse_exited() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Camera3D/MainLayer/SettingsButtonTrigger, "position:x", 0.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Camera3D/MainLayer/SettingsButton, "position:x", 0.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_settings_button_trigger_button_up() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Camera3D/MainLayer/SettingsButtonTrigger, "scale", Vector2(1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Camera3D/MainLayer/SettingsButton, "scale", Vector2(1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_settings_button_trigger_button_down() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Camera3D/MainLayer/SettingsButtonTrigger, "scale", Vector2(1.05, 1.05), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Camera3D/MainLayer/SettingsButton, "scale", Vector2(1.05, 1.05), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_settings_button_trigger_pressed() -> void:
	if !PauseManager.is_inside_settings:
		$Camera3D/MainLayer/SettingsUI.openSettings(0.5)

######################################
# QuitButton animations and functions
######################################

func _on_quit_button_trigger_button_up() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Camera3D/MainLayer/QuitButtonTrigger, "scale", Vector2(1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Camera3D/MainLayer/QuitButton, "scale", Vector2(1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_quit_button_trigger_button_down() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Camera3D/MainLayer/QuitButtonTrigger, "scale", Vector2(1.05, 1.05), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Camera3D/MainLayer/QuitButton, "scale", Vector2(1.05, 1.05), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_quit_button_trigger_mouse_entered() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Camera3D/MainLayer/QuitButtonTrigger, "position:x", 20.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Camera3D/MainLayer/QuitButton, "position:x", 20.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_quit_button_trigger_mouse_exited() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Camera3D/MainLayer/QuitButtonTrigger, "position:x", 0.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Camera3D/MainLayer/QuitButton, "position:x", 0.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_quit_button_trigger_pressed() -> void:
	get_tree().quit()

######################################
# Exit gamemode layer button functions
######################################

func _on_exit_gamemode_layer_button_pressed() -> void:
	if is_in_gamemode_select:
		deSpawnGameModeMenu()

func _on_play_story_mode_button_pressed() -> void:
	pass

func _on_play_free_mode_button_pressed() -> void:
	transitioning_scene = true
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	$Camera3D/MainLayer/TransitionFadeOut.modulate = Color(1, 1, 1, 0)
	$Camera3D/MainLayer/TransitionFadeOut.visible = true
	
	var tween = get_tree().create_tween()
	tween.connect("finished", Callable(self, "on_free_mode_fade_finished"))
	
	tween.tween_property($Camera3D/MainLayer/TransitionFadeOut, "modulate", Color(1, 1, 1, 1), 1)
	tween.tween_interval(1)

func on_free_mode_fade_finished():
	get_tree().change_scene_to_packed(world)

func _on_play_parkour_mode_button_pressed() -> void:
	pass

func _on_achievements_button_pressed() -> void:
	$Camera3D/MainLayer/AchievementsUI.spawnAchievements(0.5)

func _on_credits_button_pressed() -> void:
	$Camera3D/MainLayer/CreditsLayer.spawnCredits(0.5)
