#============================================================= #
# TheIsland_SCRIPT.gd
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

@icon("res://Textures/Icons/Script Icons/32x32/world_page.png")
extends Node

func initializeIslandProperties(_Island_Name):
	pass

@export var DayNightCycle : AnimationPlayer
@export var DayNightCycle_Sky : AnimationPlayer
@export var DayNightCycle_Sky_Transitions : AnimationTree
# animation_tree.set("parameters/Movement/transition_request", "CrouchWalk")
@export var Tick : Timer
@export var RainParticles : CPUParticles3D
@export var Clouds : MeshInstance3D
@export var Player : CharacterBody3D

func _ready() -> void:
	randomize()
	initNodes()

	AudioManager.NotificationOnScreen = false
	AudioManager.canOperate_textField = true
	IslandManager.transitioning_from_menu = false
	Global.main_menu_transitioning_scene = false
	Global.the_island_transitioning_scene = false
	
	PlayerData.loadData(IslandManager.Current_Island_Name, true)
	IslandData.loadData(IslandManager.Current_Island_Name, true)
	InventoryData.loadInventory(IslandManager.Current_Island_Name)
	
	PlayerManager.init()
	set_dof_blur(PlayerSettingsData.DOFBlur)
	set_pretty_shadows(PlayerSettingsData.PrettyShadows)
	
	if PlayerData.GAME_STATE == "SLEEPING":
		PlayerData.GAME_STATE = "NORMAL"
		set_time(360)
	else:
		set_time(TimeManager.CURRENT_TIME)
	
	Tick.start()
	
	Player.nodeSetup()
	Player.setHotbarSelectedSlot(int(str(HotbarManager.CURRENTLY_SELECTED_SLOT_NAME)[-1]))
	
	InventoryManager.chestNode = $Chest
	
	SignalBus.populate_explorer_note_ui.emit()

func _on_ready() -> void:
	AudioManager.initNotificaton(PlayerManager.AudioNotification)
	AudioManager.initNew($TheIsland_Audio, true, false, true)

func _process(_delta: float) -> void:
	RainParticles.position.x = Player.position.x
	RainParticles.position.z = Player.position.z

func initNodes():
	RainParticles.emitting = false
	RainParticles.visible = false

func set_dof_blur(value : bool) -> void:
	var cameraAttributesResource = load("res://Resources/Environment/DefaultCameraAttributes.tres")
	
	if value:
		cameraAttributesResource.dof_blur_far_enabled = true
	else:
		cameraAttributesResource.dof_blur_far_enabled = false

func set_pretty_shadows(value : bool) -> void:
	var WorldEnv = load("res://Resources/Environment/TheIslandWorldEnvironment.tres")
	
	if value:
		WorldEnv.sdfgi_enabled = true
	else:
		WorldEnv.sdfgi_enabled = false

func get_weighted_random_weather():
	var weights = [60, 10, 10, 20]
	
	var options = [1, 2, 3, 4]
	# 1 = SUNNY
	# 2 = RAIN
	# 3 = STORM
	# 4 = CLOUDY
	
	var total_weight = Utils.sum_array(weights)
	var random_value = randi() % total_weight
	var cumulative = 0
	
	for i in options.size():
		cumulative += weights[i]
		if random_value < cumulative:
			return options[i]

func set_time(minute : int):
	if !DayNightCycle.is_playing():
		DayNightCycle.play(&"cycle")
	else:
		DayNightCycle.stop()
		DayNightCycle.play(&"cycle")
	
	if DayNightCycle_Sky.is_playing():
		DayNightCycle_Sky.play(&"sky_cycle")
	else:
		DayNightCycle_Sky.stop()
		DayNightCycle_Sky.play(&"sky_cycle")
		
	TimeManager.CURRENT_TIME = minute
	
	if TimeManager.CURRENT_TIME >= 1140 or TimeManager.CURRENT_TIME < 360:
		TimeManager.DAY_STATE = "NIGHT"
	elif TimeManager.CURRENT_TIME >= 300 and TimeManager.CURRENT_TIME < 420:
		TimeManager.DAY_STATE = "DAY"
		append_random_songs(AudioManager.ISLAND_MORNING_SONGS)
	else:
		TimeManager.DAY_STATE = "DAY"
	
	# Since the animation goes for 2880 seconds and there are 
	# 1440 "minutes" in a day, we need to multiply the value by 2
	DayNightCycle.seek(minute * 2)
	DayNightCycle_Sky.seek(minute * 2)

func _on_tick() -> void:
	TimeManager.CURRENT_TIME += 1
	
	if TimeManager.CURRENT_TIME >= 1440:
		TimeManager.CURRENT_TIME = 0
		
		if !PlayerData.GAME_STATE == "SLEEPING":
			TimeManager.CURRENT_DAY += 1
	
	if TimeManager.CURRENT_TIME >= 1140 or TimeManager.CURRENT_TIME < 360:
		TimeManager.DAY_STATE = "NIGHT"
		if TimeManager.CURRENT_TIME in [19 * 60, 20 * 60, 21 * 60, 22 * 60, 23 * 60]:
			append_random_songs(AudioManager.ISLAND_NIGHT_SONGS)
	else:
		TimeManager.DAY_STATE = "DAY"

func append_random_songs(song_array: Array):
	var shuffled_songs = song_array.duplicate()
	shuffled_songs.shuffle()
	var num_songs_to_append = randi() % shuffled_songs.size() + 1
	for i in range(num_songs_to_append):
		AudioManager.IN_FRONT_SONGS.append(shuffled_songs[i])

func weatherTest():
	#var sky = load("res://Resources/Environment/TheIslandProceduralSkyMaterial.tres")
	#var tween = get_tree().create_tween()
	#$"Day-Night Cycle".stop()
	#tween.tween_property(sky, "sky_top_color", Color(0.281, 0, 0.003), 0)
	pass
