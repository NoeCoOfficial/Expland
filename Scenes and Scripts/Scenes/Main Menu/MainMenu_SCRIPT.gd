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

var loadIslandThread : Thread
var loadAchivementElementsThread : Thread

var is_in_gamemode_select = false
var is_in_absolute_gamemode_select = false
var is_in_free_mode_island_popup = false
var is_in_free_mode_create_island = false
var is_in_load_island_interface = false
var is_in_delete_popup = false
var island_element_to_free
var is_tweening = false

@onready var StartupNotice = preload("res://Scenes and Scripts/Scenes/Startup Notice/StartupNotice.tscn")
@onready var world = preload("res://Scenes and Scripts/Scenes/The Island/TheIsland.tscn")
@onready var DefaultXPos = $Camera3D/MainLayer/PlayButton.position.x

@export_group("Node references")
@export var FreeModeIslandPopupLayer : CanvasLayer
@export var TextEditNewIslandName : LineEdit
@export var fade_timer_time_left_label : Label

# ---------------------------------------------------------------------------- #
#                                    STARTUP                                   #
# ---------------------------------------------------------------------------- #

func _ready() -> void:
	initialize_audio()
	initialize_globals()
	initialize_ui()
	initialize_threads()
	initialize_buttons()
	await get_tree().create_timer(1).timeout
	onStartup()
	handle_protective_layer_visibility()

func initialize_audio() -> void:
	AudioManager.NotificationOnScreen = false
	AudioManager.initNotificaton($Camera3D/MainLayer/AudioNotificationLayer/AudioNotification)
	AudioManager.initNew($MainMenu_Audio, false, false, true)
	AudioManager.canOperate_textField = true

func initialize_globals() -> void:
	AchievementsManager.CURRENT_ACHIEVEMENTS_UI = $Camera3D/MainLayer/AchievementsUI
	AchievementsManager.CURRENT_NOTIFICATION_NODE = $Camera3D/MainLayer/AchievementNotificationLayer/AchievementNotification
	AchievementsManager.CURRENT_UI_GRID_CONTAINER = $Camera3D/MainLayer/AchievementsUI/MainLayer/ScrollContainer/GridContainer
	DialogueManager.DialogueInterface = $Camera3D/MainLayer/DialogueLayer/DialogueInterface
	
	PauseManager.is_paused = false
	Global.main_menu_transitioning_scene = false
	Global.the_island_transitioning_scene = false
	GlobalData.loadGlobal()
	PlayerSettingsData.loadSettings()

func initialize_ui() -> void:
	$Camera3D/MainLayer/GreyLayerGamemodeLayer.hide()
	$Camera3D/MainLayer/GreyLayerGamemodeLayer.modulate = Color(1, 1, 1, 0)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	IslandManager.resetAttributes()
	IslandAccessOrder.load_order()

func initialize_threads() -> void:
	loadIslandThread = Thread.new()
	var loadIslandThread_callable = Callable($Camera3D/MainLayer/FreeModeIslandPopup/LoadIslandPopup, "loadIslands")
	loadIslandThread.start(loadIslandThread_callable)
	
	loadAchivementElementsThread = Thread.new()
	var loadAchivementElementsThread_callable = Callable(AchievementsManager, "populateGridContainer")
	loadAchivementElementsThread.start(loadAchivementElementsThread_callable)

func initialize_buttons() -> void:
	Utils.set_center_offset($Camera3D/MainLayer/PlayButton)
	Utils.set_center_offset($Camera3D/MainLayer/PlayButtonTrigger)
	Utils.set_center_offset($Camera3D/MainLayer/SettingsButton)
	Utils.set_center_offset($Camera3D/MainLayer/SettingsButtonTrigger)
	Utils.set_center_offset($Camera3D/MainLayer/QuitButton)
	Utils.set_center_offset($Camera3D/MainLayer/QuitButtonTrigger)

func handle_protective_layer_visibility() -> void:
	if PlayerSettingsData.quickAnimations:
		$Camera3D/MainLayer/ProtectiveLayer.visible = false
	else:
		await get_tree().create_timer(2).timeout
		$Camera3D/MainLayer/ProtectiveLayer.visible = false

func change_to_startup_notice() -> void:
	get_tree().change_scene_to_packed(StartupNotice)

func fadeOut(node):
	var tween = get_tree().create_tween()
	tween.tween_property(node, "modulate", Color(0, 0, 0, 0), 3)

func _on_ready() -> void:
	pass

func onStartup():
	if !OS.has_feature("debug"):
		$Camera3D/MainLayer/AudioNotificationLayer/fade_timer_time_left.hide()
		$Camera3D/MainLayer/AudioNotificationLayer/fade_timer_time_left_title.hide()
	
	fadeOut($Camera3D/MainLayer/TopLayer/FadeOut)
	$Camera3D/MainLayer/Version_LBL.visible = true
	
	# Menu animation (in the form of tweens)
	if PlayerSettingsData.quickAnimations:
		$Camera3D/MainLayer/Logo.position.x = -15
		$Camera3D/MainLayer/PlayButton.position = Vector2(0, 203)
		$Camera3D/MainLayer/PlayButtonTrigger.position = Vector2(0, 203)
		$Camera3D/MainLayer/SettingsButton.position = Vector2(0, 297)
		$Camera3D/MainLayer/SettingsButtonTrigger.position = Vector2(0, 297)
		$Camera3D/MainLayer/QuitButton.position = Vector2(0, 383)
		$Camera3D/MainLayer/QuitButtonTrigger.position = Vector2(0, 383)
		$Camera3D/MainLayer/AchievementsButton.position = Vector2(947, 558)
		$Camera3D/MainLayer/CreditsButton.position = Vector2(1018, 605)
	else:
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

# ---------------------------------------------------------------------------- #
#                                     INPUT                                    #
# ---------------------------------------------------------------------------- #

func _input(_event: InputEvent) -> void:
	if !Global.main_menu_transitioning_scene:
		if Input.is_action_just_pressed("Exit") and !is_tweening:  # Check if not tweening
			if is_in_gamemode_select and !DialogueManager.is_in_interface and !is_in_free_mode_island_popup and !is_in_free_mode_create_island and !is_in_load_island_interface and !is_in_delete_popup:
				deSpawnGameModeMenu()
			
		if Input.is_action_just_pressed("Exit"):
			if PauseManager.is_inside_settings:
				$Camera3D/MainLayer/SettingsUI.closeSettings(0.5)
			
			if PauseManager.is_inside_achievements_ui:
				$Camera3D/MainLayer/AchievementsUI.despawnAchievements(0.5)
			
			if PauseManager.is_inside_credits:
				$Camera3D/MainLayer/CreditsLayer.despawnCredits(0.5)
			
			if is_in_load_island_interface:
				$Camera3D/MainLayer/FreeModeIslandPopup/LoadIslandPopup.visible = false
				$Camera3D/MainLayer/FreeModeIslandPopup/NewIslandOrLoadIslandPopup.show()
				FreeModeIslandPopupLayer.visible = true
				is_in_load_island_interface = false
				is_in_free_mode_island_popup = true
			
			elif is_in_free_mode_island_popup:
				FreeModeIslandPopupLayer.visible = false
				is_in_free_mode_island_popup = false
				is_in_gamemode_select = true
				is_in_absolute_gamemode_select = true
				
			elif is_in_free_mode_create_island:
				$Camera3D/MainLayer/FreeModeIslandPopup/NewIslandOrLoadIslandPopup.show()
				$Camera3D/MainLayer/FreeModeIslandPopup/NewIslandPopup.hide()
				is_in_free_mode_island_popup = true
				is_in_free_mode_create_island = false
				is_in_gamemode_select = false
				is_in_absolute_gamemode_select = false
			
			elif is_in_delete_popup:
				$Camera3D/MainLayer/DeleteIslandPopup.visible = false
				$Camera3D/MainLayer/DeleteIslandPopup.hide()
				is_in_delete_popup = false
				is_in_load_island_interface = true

# ---------------------------------------------------------------------------- #
#                                    PROCESS                                   #
# ---------------------------------------------------------------------------- #

func _process(_delta: float) -> void:
	if OS.has_feature("debug"):
		fade_timer_time_left_label.text = str(int(AudioManager.FADE_TIMER_TIME_LEFT))

# ---------------------------------------------------------------------------- #
#                             SPAWN GAME MODE MENU                             #
# ---------------------------------------------------------------------------- #

func spawnGameModeMenu():
	is_in_absolute_gamemode_select = true
	is_tweening = true  # Set tweening flag to true
	
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
	is_tweening = false  # Set tweening flag to false

func deSpawnGameModeMenu():
	if !Global.main_menu_transitioning_scene and !is_tweening:  # Check if not tweening
		is_in_absolute_gamemode_select = false
		is_in_gamemode_select = false
		is_tweening = true  # Set tweening flag to true
		
		$Camera3D/MainLayer/PlayButtonTrigger.visible = true
		
		var tween = get_tree().create_tween().set_parallel()
		
		tween.tween_property($Camera3D/MainLayer/GreyLayerGamemodeLayer, "modulate", Color(1, 1, 1, 0), 1)
		tween.tween_property($Camera3D/MainLayer/GreyLayerGamemodeLayer, "visible", false, 0).set_delay(1)
		
		tween.tween_property($Camera3D/MainLayer/ExitGamemodeLayerButton, "position", Vector2(15, -54), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
		
		tween.tween_property($Camera3D/MainLayer/GameModeLayer/BG_StoryMode, "position:y", 28, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
		tween.tween_property($Camera3D/MainLayer/GameModeLayer/BG_FreeMode, "position:y", 28, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO).set_delay(0.1)
		tween.tween_property($Camera3D/MainLayer/GameModeLayer/BG_ParkourMode, "position:y", 28, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO).set_delay(0.2)

func on_despawn_game_mode_menu_tween_finished():
	is_tweening = false  # Set tweening flag to false

# ---------------------------------------------------------------------------- #
#                     PLAY BUTTON ANIMATIONS AND FUNCTIONS                     #
# ---------------------------------------------------------------------------- #

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
	if !Global.main_menu_transitioning_scene:
		var tween = get_tree().create_tween().set_parallel()
		tween.tween_property($Camera3D/MainLayer/PlayButtonTrigger, "scale", Vector2(1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		tween.tween_property($Camera3D/MainLayer/PlayButton, "scale", Vector2(1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_play_button_trigger_pressed() -> void:
	spawnGameModeMenu()

# ---------------------------------------------------------------------------- #
#                   SETTINGS BUTTON ANIMATIONS AND FUNCTIONS                   #
# ---------------------------------------------------------------------------- #

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

# ---------------------------------------------------------------------------- #
#                     QUIT BUTTON ANIMATIONS AND FUNCTIONS                     #
# ---------------------------------------------------------------------------- #

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

# ---------------------------------------------------------------------------- #
#                 EXIT GAMEMODE BUTTON ANIMATIONS AND FUNCTIONS                #
# ---------------------------------------------------------------------------- #

func _on_exit_gamemode_layer_button_pressed() -> void:
	if is_in_gamemode_select:
		deSpawnGameModeMenu()

# ---------------------------------------------------------------------------- #
#                            GAMEMODE SELECT BUTTONS                           #
# ---------------------------------------------------------------------------- #

func _on_play_story_mode_button_pressed() -> void:
	startStoryMode()

func _on_play_free_mode_button_pressed() -> void:
	FreeModeIslandPopupLayer.visible = true
	$Camera3D/MainLayer/FreeModeIslandPopup/NewIslandOrLoadIslandPopup.show()
	$Camera3D/MainLayer/FreeModeIslandPopup/NewIslandPopup.hide()
	is_in_free_mode_island_popup = true
	is_in_gamemode_select = false
	is_in_absolute_gamemode_select = false

func _on_play_parkour_mode_button_pressed() -> void:
	pass

func _on_achievements_button_pressed() -> void:
	$Camera3D/MainLayer/AchievementsUI.spawnAchievements(0.5)

func _on_credits_button_pressed() -> void:
	$Camera3D/MainLayer/CreditsLayer.spawnCredits(0.5)

# ---------------------------------------------------------------------------- #
#                                ISLAND CREATION                               #
# ---------------------------------------------------------------------------- #

func _on_new_island_name_text_input(event: InputEventKey) -> void:
	var invalid_chars = ["/", "\\", "|", "*", "<", ">", "\"", "?", ":", "+"]
	
	if event.unicode_char in invalid_chars:
		event.accepted = false

func _on_free_mode_in_popup_new_island_button_pressed() -> void:
	var text_edit = $Camera3D/MainLayer/FreeModeIslandPopup/NewIslandPopup/Island_Name_TextEdit
	var text = text_edit.text
	var invalid_chars = ["/", "\\", "|", "*", "<", ">", "\"", "?", ":", "+", "\t", "\n", "\r"]
	var sanitized_name = ""
	var has_valid_char = false
	
	for character in text:
		if character not in invalid_chars:
			sanitized_name += character
			if character != " ":
				has_valid_char = true
	
	# Remove trailing spaces
	while sanitized_name.ends_with(" "):
		sanitized_name = sanitized_name.substr(0, sanitized_name.length() - 1)
	
	if sanitized_name.length() > 100:
		sanitized_name = sanitized_name.substr(0, 100)
	
	# Remove trailing spaces again after length check
	while sanitized_name.ends_with(" "):
		sanitized_name = sanitized_name.substr(0, sanitized_name.length() - 1)
	
	text_edit.text = sanitized_name
	
	if not has_valid_char:
		$Camera3D/MainLayer/FreeModeIslandPopup/NewIslandPopup/Island_Name_TextEdit.text = ""
		print("Invalid Island name: Name cannot be empty, consist only of spaces or have invalid characters.")
		$Camera3D/MainLayer/FreeModeIslandPopup/MinimalAlert.spawn_minimal_alert(4, 0.5, 0.5, "Island name cannot be empty, contain only spaces, or contain invalid characters.")
		return
	
	# Check if the sanitized name already exists
	var dir = DirAccess.open("user://saveData/Free Mode/Islands/")
	if dir:
		dir.list_dir_begin()
		var folder_name = dir.get_next()
		while folder_name != "":
			if dir.current_is_dir() and folder_name != "." and folder_name != "..":
				if folder_name.to_lower() == sanitized_name.to_lower():
					print("Island name already exists: ", sanitized_name)
					$Camera3D/MainLayer/FreeModeIslandPopup/MinimalAlert.spawn_minimal_alert(4, 0.5, 0.5, "Island name already exists. Please choose a different name.")
					return
			folder_name = dir.get_next()
		dir.list_dir_end()
	
	print("Valid island name: ", sanitized_name)
	$Camera3D/MainLayer/FreeModeIslandPopup/NewIslandPopup/Island_Name_TextEdit.editable = false
	$Camera3D/MainLayer/FreeModeIslandPopup/NewIslandPopup/Island_Name_TextEdit.release_focus()
	$Camera3D/MainLayer/FreeModeIslandPopup/NewIslandPopup/Free_ModeInPopupNewIslandButton.release_focus()
	
	IslandManager.transitioning_from_menu = true
	
	IslandManager.transitioningFromNewIsland = true
	
	Global.main_menu_transitioning_scene = true
	$MainMenu_Audio.audibleOnlyFadeOutAllSongs()
	IslandManager.set_current_island(sanitized_name)
	IslandManager.Current_Game_Mode = "FREE"
	
	Utils.createBaseSaveFolder()
	Utils.createIslandSaveFolder(sanitized_name, IslandManager.Current_Game_Mode)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	$Camera3D/MainLayer/TopLayer/TransitionFadeOut.modulate = Color(1, 1, 1, 0)
	$Camera3D/MainLayer/TopLayer/TransitionFadeOut.visible = true
	
	var tween = get_tree().create_tween()
	tween.connect("finished", Callable(self, "on_free_mode_fade_finished"))
	
	tween.tween_property($Camera3D/MainLayer/TopLayer/TransitionFadeOut, "modulate", Color(1, 1, 1, 1), 1)
	tween.tween_interval(1)

func goToIsland(island_name : String, _gamemode : String):
	Global.main_menu_transitioning_scene = true
	$MainMenu_Audio.audibleOnlyFadeOutAllSongs()
	IslandManager.transitioning_from_menu = true
	IslandManager.set_current_island(island_name)
	IslandManager.Current_Game_Mode = "FREE"
	
	Utils.createBaseSaveFolder()
	Utils.createIslandSaveFolder(island_name, IslandManager.Current_Game_Mode)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	$Camera3D/MainLayer/TopLayer/TransitionFadeOut.modulate = Color(1, 1, 1, 0)
	$Camera3D/MainLayer/TopLayer/TransitionFadeOut.visible = true
	
	var tween = get_tree().create_tween()
	tween.connect("finished", Callable(self, "on_free_mode_fade_finished"))
		
	tween.tween_property($Camera3D/MainLayer/TopLayer/TransitionFadeOut, "modulate", Color(1, 1, 1, 1), 1)
	tween.tween_interval(1)

func on_free_mode_fade_finished():
	get_tree().change_scene_to_packed(world)

func _on_new_island_button_pressed() -> void:
	is_in_free_mode_island_popup = false
	is_in_free_mode_create_island = true
	$Camera3D/MainLayer/FreeModeIslandPopup/NewIslandOrLoadIslandPopup.hide()
	$Camera3D/MainLayer/FreeModeIslandPopup/NewIslandPopup.show()

func _on_load_island_button_pressed() -> void:
	$Camera3D/MainLayer/FreeModeIslandPopup/LoadIslandPopup.showPopup()
	is_in_load_island_interface = true
	is_in_free_mode_island_popup = false
	
	var vbox_container = $Camera3D/MainLayer/FreeModeIslandPopup/LoadIslandPopup/ScrollContainer/VBoxContainer
	if vbox_container.get_child_count() == 0:
		$Camera3D/MainLayer/FreeModeIslandPopup/LoadIslandPopup/NoSavedIslandsNotice.visible = true
	else:
		$Camera3D/MainLayer/FreeModeIslandPopup/LoadIslandPopup/NoSavedIslandsNotice.visible = false

func ShowDeletePopup(Island_Name, element_to_free):
	island_element_to_free = element_to_free
	is_in_load_island_interface = false
	is_in_delete_popup = true
	$Camera3D/MainLayer/DeleteIslandPopup/DeleteIslandPopupMain.showDeleteIslandPopup(Island_Name)

func _on_delete_island_yes_pressed() -> void:
	var Island_To_Delete = $Camera3D/MainLayer/DeleteIslandPopup/DeleteIslandPopupMain.getIslandToDelete()
	
	island_element_to_free.queue_free()
	
	if IslandManager.FreeMode_Island_Count == 0:
		$Camera3D/MainLayer/FreeModeIslandPopup/LoadIslandPopup/NoSavedIslandsNotice.visible = true
	
	$Camera3D/MainLayer/FreeModeIslandPopup/LoadIslandPopup.showPopup()
	
	$Camera3D/MainLayer/DeleteIslandPopup.visible = false
	$Camera3D/MainLayer/DeleteIslandPopup.hide()
	is_in_delete_popup = false
	is_in_load_island_interface = true
	
	Utils.delete_free_mode_island(Island_To_Delete)
	IslandAccessOrder.remove_island(Island_To_Delete)

func _on_delete_island_no_pressed() -> void:
	$Camera3D/MainLayer/DeleteIslandPopup.visible = false
	$Camera3D/MainLayer/DeleteIslandPopup.hide()
	is_in_delete_popup = false
	is_in_load_island_interface = true

# ---------------------------------------------------------------------------- #
#                                     OTHER                                    #
# ---------------------------------------------------------------------------- #

func _exit_tree() -> void:
	loadIslandThread.wait_to_finish()

func _on_tree_entered() -> void:
	Global.is_in_main_menu = true

func _on_tree_exited() -> void:
	Global.is_in_main_menu = false

func _on_checks_timer_timeout() -> void:
	if Global.is_first_time_in_menu:
		Global.is_first_time_in_menu = false
		
		if PlayerSettingsData.showStartupScreen:
			call_deferred("change_to_startup_notice")
		else:
			$MainMenu_Audio.Start(false, true)
	else:
		$MainMenu_Audio.Start(false, true)

func _on_island_name_text_edit_focus_entered() -> void:
	AudioManager.canOperate_textField = false
	if IslandManager.transitioning_from_menu:
		$Camera3D/MainLayer/FreeModeIslandPopup/NewIslandPopup/Island_Name_TextEdit.release_focus()
		$Camera3D/MainLayer/FreeModeIslandPopup/NewIslandPopup/Island_Name_TextEdit.editable = false
		$Camera3D/MainLayer/FreeModeIslandPopup/NewIslandPopup/Island_Name_TextEdit.selecting_enabled = false

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
		DialogueManager.startDialogue(DialogueManager.mainMenuStoryModeDialogue_1)
	else:
		DialogueManager.setStoryModeID(2)
		DialogueManager.startDialogue(DialogueManager.mainMenuStoryModeDialogue_2)

func _on_dialogue_interface_finished_dialogue(StoryModeID: int) -> void:
	# NOTE: StoryModeID will always be the same as DialogueManager.Current_StoryModeID
	if StoryModeID == 1:
		pass
	if StoryModeID == 2:
		$Camera3D/MainLayer/ProtectiveLayer.visible = true
		
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		$Camera3D/MainLayer/TopLayer/TransitionFadeOut.modulate = Color(1, 1, 1, 0)
		$Camera3D/MainLayer/TopLayer/TransitionFadeOut.visible = true
		
		var tween = get_tree().create_tween()
		tween.connect("finished", Callable(self, "on_story_mode_fade_finished"))
		
		tween.tween_property($Camera3D/MainLayer/TopLayer/TransitionFadeOut, "modulate", Color(1, 1, 1, 1), 1)
		tween.tween_interval(1)

func on_story_mode_fade_finished():
	pass
