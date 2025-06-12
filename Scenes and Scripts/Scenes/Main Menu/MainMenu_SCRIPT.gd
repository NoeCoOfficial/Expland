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

@icon("uid://bf37ev5d10xuh")
extends Control

var is_in_gamemode_select = false
var is_in_absolute_gamemode_select = false
var is_tweening = false

@onready var StartupNotice = preload("res://Scenes and Scripts/Scenes/Startup Notice/StartupNotice.tscn")
@onready var world = preload("uid://c5jkrckgqd0w6")
@onready var StoryModeStartCutscene = preload("uid://nlp0xy1m65tp")
@onready var DefaultXPos = $MainLayer/PlayButton.position.x

@export_group("Node references")

# ---------------------------------------------------------------------------- #
#                                    STARTUP                                   #
# ---------------------------------------------------------------------------- #

func _ready() -> void:
	TimeManager.speedrun_timer_reset()
	if !Global.is_first_time_in_menu:
		Global.is_first_time_in_menu_no_startup = true
	initialize_globals()
	initialize_ui()
	initialize_buttons()
	await get_tree().create_timer(1).timeout
	onStartup()
	handle_protective_layer_visibility()

func initialize_globals() -> void:
	AchievementsManager.CURRENT_ACHIEVEMENTS_UI = $MainLayer/AchievementsUI
	AchievementsManager.CURRENT_NOTIFICATION_NODE = $MainLayer/AchievementNotificationLayer/AchievementNotification
	AchievementsManager.CURRENT_UI_GRID_CONTAINER = $MainLayer/AchievementsUI/MainLayer/ScrollContainer/GridContainer
	DialogueManager.DialogueInterface = $MainLayer/DialogueLayer/DialogueInterface
	
	PauseManager.is_paused = false
	Global.main_menu_transitioning_scene = false
	Global.transitioning_to_main_menu_from_island = false
	GlobalData.loadGlobal()
	
	PlayerSettingsData.loadSettings(
		PlayerSettingsData.SAVE_PATH, 
		ProjectSettings.get_setting("global/SECURITY_KEY_SETTINGS")
	)

func initialize_ui() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	IslandManager.resetAttributes()

func initialize_buttons() -> void:
	Utils.set_center_offset($MainLayer/PlayButton)
	Utils.set_center_offset($MainLayer/PlayButtonTrigger)
	Utils.set_center_offset($MainLayer/SettingsButton)
	Utils.set_center_offset($MainLayer/SettingsButtonTrigger)
	Utils.set_center_offset($MainLayer/QuitButton)
	Utils.set_center_offset($MainLayer/QuitButtonTrigger)

func handle_protective_layer_visibility() -> void:
	if PlayerSettingsData.quickAnimations:
		$MainLayer/ProtectiveLayer.visible = false
	else:
		await get_tree().create_timer(2).timeout
		$MainLayer/ProtectiveLayer.visible = false

func change_to_startup_notice() -> void:
	get_tree().change_scene_to_packed(StartupNotice)

func fadeOut(node):
	Global.is_main_menu_black_screen_fading_out = true
	var tween = get_tree().create_tween()
	tween.connect("finished", onfadeOutFinished)
	tween.tween_property(node, "modulate", Color(0, 0, 0, 0), 3)

func onfadeOutFinished():
	Global.is_main_menu_black_screen_fading_out = false

func _on_ready() -> void:
	pass

func onStartup():
	if !OS.is_debug_build():
		$MainLayer/AudioNotificationLayer/fade_timer_time_left.hide()
		$MainLayer/AudioNotificationLayer/fade_timer_time_left_title.hide()
	
	#if Global.is_first_time_in_menu_no_startup:
		#$AlertLayer/AlertLayer.spawnAlert("v0.7.1 notice", "", 15, 0.5)
	
	fadeOut($TopLayer/FadeOut)
	
	$MainLayer/Version_LBL.visible = true
	
	# Menu animation (in the form of tweens)
	if PlayerSettingsData.quickAnimations:
		$MainLayer/Logo.position.x = -15
		$MainLayer/PlayButton.position = Vector2(0, 203)
		$MainLayer/PlayButtonTrigger.position = Vector2(0, 203)
		$MainLayer/SettingsButton.position = Vector2(0, 297)
		$MainLayer/SettingsButtonTrigger.position = Vector2(0, 297)
		$MainLayer/QuitButton.position = Vector2(0, 383)
		$MainLayer/QuitButtonTrigger.position = Vector2(0, 383)
		$MainLayer/AchievementsButton.position = Vector2(947, 508.0)
		$MainLayer/UpdatesButton.position = Vector2(1018, 556)
		$MainLayer/CreditsButton.position = Vector2(1018, 605)
	else:
		var tween = get_tree().create_tween().set_parallel()
		tween.tween_property($MainLayer/Logo, "position:x", -15, 1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(0.5)
		tween.tween_property($MainLayer/PlayButton, "position", Vector2(0, 203), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(1.0)
		tween.tween_property($MainLayer/PlayButtonTrigger, "position", Vector2(0, 203), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(1.0)
		tween.tween_property($MainLayer/SettingsButton, "position", Vector2(0, 297), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(1.2)
		tween.tween_property($MainLayer/SettingsButtonTrigger, "position", Vector2(0, 297), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(1.2)
		tween.tween_property($MainLayer/QuitButton, "position", Vector2(0, 383), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(1.4)
		tween.tween_property($MainLayer/QuitButtonTrigger, "position", Vector2(0, 383), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(1.4)
		tween.tween_property($MainLayer/AchievementsButton, "position", Vector2(947, 508), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(1.2)
		tween.tween_property($MainLayer/UpdatesButton, "position", Vector2(1018, 556), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(1.3)
		tween.tween_property($MainLayer/CreditsButton, "position", Vector2(1018, 605), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(1.4)

# ---------------------------------------------------------------------------- #
#                                     INPUT                                    #
# ---------------------------------------------------------------------------- #

func _input(_event: InputEvent) -> void:
	if !Global.main_menu_transitioning_scene:
		if Input.is_action_just_pressed("Exit") and !is_tweening and !DialogueManager.is_in_absolute_interface and !PauseManager.is_inside_alert:  # Check if not tweening
			if is_in_gamemode_select and !DialogueManager.is_in_interface:
				deSpawnGameModeMenu()
			
		if Input.is_action_just_pressed("Exit") and !DialogueManager.is_in_absolute_interface:
			if PauseManager.is_inside_settings:
				$MainLayer/SettingsUI.closeSettings(0.5)
			
			if PauseManager.is_inside_updates_popup:
				$MainLayer/UpdatesLayer/UpdatesLayer.despawnAlert(0.5)
			
			if PauseManager.is_inside_achievements_ui:
				$MainLayer/AchievementsUI.despawnAchievements(0.5)
			
			if PauseManager.is_inside_credits:
				$MainLayer/CreditsLayer.despawnCredits(0.5)

# ---------------------------------------------------------------------------- #
#                             SPAWN GAME MODE MENU                             #
# ---------------------------------------------------------------------------- #

func spawnGameModeMenu():
	is_in_absolute_gamemode_select = true
	is_tweening = true  # Set tweening flag to true
	
	$MainLayer/PlayButtonTrigger.visible = false
	
	$MainLayer/GamemodeBlurLayer.fadeInBlur(0.5, 2.19, true, 0.8)
	
	var tween = get_tree().create_tween().set_parallel()
	tween.connect("finished", Callable(self, "on_spawn_game_mode_menu_tween_finished"))
	
	tween.tween_property($MainLayer/ExitGamemodeLayerButton, "position", Vector2(15, 11), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
	tween.tween_property($MainLayer/GameModeLayer/BG_StoryMode, "position:y", -580, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($MainLayer/GameModeLayer/BG_FreeMode, "position:y", -580, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(0.1)
	tween.tween_property($MainLayer/GameModeLayer/BG_ParkourMode, "position:y", -580, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(0.2)

func on_spawn_game_mode_menu_tween_finished():
	is_in_gamemode_select = true
	is_tweening = false  # Set tweening flag to false

func deSpawnGameModeMenu():
	if !Global.main_menu_transitioning_scene and !is_tweening:  # Check if not tweening
		is_in_absolute_gamemode_select = false
		is_in_gamemode_select = false
		is_tweening = true  # Set tweening flag to true
		
		$MainLayer/PlayButtonTrigger.visible = true
		$MainLayer/GamemodeBlurLayer.fadeOutBlur(1.0)
		
		var tween = get_tree().create_tween().set_parallel()
		
		tween.tween_property($MainLayer/ExitGamemodeLayerButton, "position", Vector2(15, -54), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
		
		tween.tween_property($MainLayer/GameModeLayer/BG_StoryMode, "position:y", 28, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
		tween.tween_property($MainLayer/GameModeLayer/BG_FreeMode, "position:y", 28, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO).set_delay(0.1)
		tween.tween_property($MainLayer/GameModeLayer/BG_ParkourMode, "position:y", 28, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO).set_delay(0.2)

func on_despawn_game_mode_menu_tween_finished():
	is_tweening = false  # Set tweening flag to false

# ---------------------------------------------------------------------------- #
#                     PLAY BUTTON ANIMATIONS AND FUNCTIONS                     #
# ---------------------------------------------------------------------------- #

func _on_play_button_trigger_mouse_entered() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($MainLayer/PlayButtonTrigger, "position:x", 20.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($MainLayer/PlayButton, "position:x", 20.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_play_button_trigger_mouse_exited() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($MainLayer/PlayButtonTrigger, "position:x", 0.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($MainLayer/PlayButton, "position:x", 0.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_play_button_trigger_button_down() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($MainLayer/PlayButtonTrigger, "scale", Vector2(1.05, 1.05), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($MainLayer/PlayButton, "scale", Vector2(1.05, 1.05), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_play_button_trigger_button_up() -> void:
	if !Global.main_menu_transitioning_scene:
		var tween = get_tree().create_tween().set_parallel()
		tween.tween_property($MainLayer/PlayButtonTrigger, "scale", Vector2(1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		tween.tween_property($MainLayer/PlayButton, "scale", Vector2(1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_play_button_trigger_pressed() -> void:
	spawnGameModeMenu()

# ---------------------------------------------------------------------------- #
#                   SETTINGS BUTTON ANIMATIONS AND FUNCTIONS                   #
# ---------------------------------------------------------------------------- #

func _on_settings_button_trigger_mouse_entered() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($MainLayer/SettingsButtonTrigger, "position:x", 20.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($MainLayer/SettingsButton, "position:x", 20.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_settings_button_trigger_mouse_exited() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($MainLayer/SettingsButtonTrigger, "position:x", 0.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($MainLayer/SettingsButton, "position:x", 0.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_settings_button_trigger_button_up() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($MainLayer/SettingsButtonTrigger, "scale", Vector2(1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($MainLayer/SettingsButton, "scale", Vector2(1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_settings_button_trigger_button_down() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($MainLayer/SettingsButtonTrigger, "scale", Vector2(1.05, 1.05), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($MainLayer/SettingsButton, "scale", Vector2(1.05, 1.05), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_settings_button_trigger_pressed() -> void:
	if !PauseManager.is_inside_settings:
		$MainLayer/SettingsUI.openSettings(0.5)

# ---------------------------------------------------------------------------- #
#                     QUIT BUTTON ANIMATIONS AND FUNCTIONS                     #
# ---------------------------------------------------------------------------- #

func _on_quit_button_trigger_button_up() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($MainLayer/QuitButtonTrigger, "scale", Vector2(1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($MainLayer/QuitButton, "scale", Vector2(1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_quit_button_trigger_button_down() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($MainLayer/QuitButtonTrigger, "scale", Vector2(1.05, 1.05), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($MainLayer/QuitButton, "scale", Vector2(1.05, 1.05), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_quit_button_trigger_mouse_entered() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($MainLayer/QuitButtonTrigger, "position:x", 20.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($MainLayer/QuitButton, "position:x", 20.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_quit_button_trigger_mouse_exited() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($MainLayer/QuitButtonTrigger, "position:x", 0.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($MainLayer/QuitButton, "position:x", 0.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_quit_button_trigger_pressed() -> void:
	get_tree().quit()



func _on_exit_gamemode_layer_button_pressed() -> void:
	if is_in_gamemode_select:
		deSpawnGameModeMenu()

# ---------------------------------------------------------------------------- #
#                            GAMEMODE SELECT BUTTONS                           #
# ---------------------------------------------------------------------------- #

func _on_play_story_mode_button_pressed() -> void:
	$AlertLayer/StoryModeDemoNotice.spawnAlert("Demo notice", "", 16, 0.5)
	
	#startStoryMode() TODO


func _on_story_mode_demo_notice_play_button_pressed() -> void:
	$MainLayer/ProtectiveLayer.visible = true
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	$TopLayer/TransitionFadeOut.modulate = Color(1, 1, 1, 0)
	$TopLayer/TransitionFadeOut.visible = true
	
	var tween = get_tree().create_tween()
	tween.connect("finished", Callable(self, "_on_story_mode_demo_notice_play_button_pressed_fade_finished"))
	
	tween.tween_property($TopLayer/TransitionFadeOut, "modulate", Color(1, 1, 1, 1), 1)
	tween.tween_interval(1)

func _on_story_mode_demo_notice_play_button_pressed_fade_finished():
	PauseManager.is_inside_alert = false
	IslandManager.Current_Game_Mode = "STORY"
	get_tree().change_scene_to_file("uid://c5jkrckgqd0w6")


func _on_play_free_mode_button_pressed() -> void:
	pass

func _on_play_parkour_mode_button_pressed() -> void:
	pass

###############################################################################

func _on_achievements_button_pressed() -> void:
	$MainLayer/AchievementsUI.spawnAchievements(0.5)

func _on_updates_button_pressed() -> void:
	$MainLayer/UpdatesLayer/UpdatesLayer.popupAlert(0.5)

func _on_credits_button_pressed() -> void:
	$MainLayer/CreditsLayer.spawnCredits(0.5)

# ---------------------------------------------------------------------------- #
#                                     OTHER                                    #
# ---------------------------------------------------------------------------- #

func _exit_tree() -> void:
	pass

func _on_tree_entered() -> void:
	Global.is_in_main_menu = true

func _on_tree_exited() -> void:
	Global.is_first_time_in_menu_no_startup = false
	Global.is_in_main_menu = false

func _on_checks_timer_timeout() -> void:
	if Global.is_first_time_in_menu:
		Global.is_first_time_in_menu = false
		
		if PlayerSettingsData.showStartupScreen:
			call_deferred("change_to_startup_notice")

func _on_island_name_text_edit_focus_entered() -> void:
	AudioManager.canOperate_textField = false
	if IslandManager.transitioning_from_menu:
		$MainLayer/FreeModeIslandPopup/NewIslandPopup/Island_Name_TextEdit.release_focus()
		$MainLayer/FreeModeIslandPopup/NewIslandPopup/Island_Name_TextEdit.editable = false
		$MainLayer/FreeModeIslandPopup/NewIslandPopup/Island_Name_TextEdit.selecting_enabled = false

func _on_island_name_text_edit_focus_exited() -> void:
	AudioManager.canOperate_textField = true

func _on_load_island_element_text_edit_focus_entered() -> void:
	AudioManager.canOperate_textField = false

func _on_load_island_element_text_edit_focus_exited() -> void:
	AudioManager.canOperate_textField = true

############################################

func startStoryMode():
	if !StoryModeManager.has_done_first_story_msg:
		StoryModeManager.has_done_first_story_msg = true
		DialogueManager.setStoryModeID(1)
		DialogueManager.startDialogue(DialogueManager.StoryMode_Dialogue_1)
	else:
		DialogueManager.setStoryModeID(2)
		DialogueManager.startDialogue(DialogueManager.StoryMode_Dialogue_2)

func _on_dialogue_interface_finished_dialogue(StoryModeID: int) -> void:
	# NOTE: StoryModeID will always be the same as DialogueManager.Current_StoryModeID
	if StoryModeID == 1:
		pass
	if StoryModeID == 2:
		$MainLayer/ProtectiveLayer.visible = true
		
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		$TopLayer/TransitionFadeOut.modulate = Color(1, 1, 1, 0)
		$TopLayer/TransitionFadeOut.visible = true
		
		var tween = get_tree().create_tween()
		tween.connect("finished", Callable(self, "on_story_mode_fade_finished"))
		
		tween.tween_property($TopLayer/TransitionFadeOut, "modulate", Color(1, 1, 1, 1), 1)
		tween.tween_interval(1)

func on_story_mode_fade_finished():
	IslandManager.Current_Game_Mode = "STORY"
	get_tree().change_scene_to_packed(StoryModeStartCutscene)

func _on_tree_exiting() -> void:
	pass

############################################

func _on_v_0_7_1_btn_pressed() -> void:
	for child in $MainLayer/UpdatesLayer/UpdatesLayer/MainLayer/VersionInfoTextScrollContainer/VBoxContainer.get_children():
		if str(child.name) == "v0_7_1":
			child.visible = true
		else:
			child.visible = false
