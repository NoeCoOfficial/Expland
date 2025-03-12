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
@export var DayNightCycle_Rotation : AnimationPlayer
@export var DayNightCycle_Sky : AnimationPlayer

@export var Tick : Timer
@export var RainParticles : CPUParticles3D
@export var Clouds : MeshInstance3D
@export var Player : CharacterBody3D

var transitioning_weather = false

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
	init_weather()
	
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
	var cameraAttributesResource = load("uid://cskddrxjnggrw")
	
	if value:
		cameraAttributesResource.dof_blur_far_enabled = true
	else:
		cameraAttributesResource.dof_blur_far_enabled = false

func set_pretty_shadows(value : bool) -> void:
	var IslandWorldEnv = load("uid://dgtwdwq2n0x1v")
	
	if value:
		IslandWorldEnv.sdfgi_enabled = true
	else:
		IslandWorldEnv.sdfgi_enabled = false

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
	
	if DayNightCycle_Rotation.is_playing():
		DayNightCycle_Rotation.play(&"rotation_cycle")
	else:
		DayNightCycle_Rotation.stop()
		DayNightCycle_Rotation.play(&"rotation_cycle")
		
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
	DayNightCycle_Rotation.seek(minute * 2)
	DayNightCycle_Sky.seek(minute * 2)

func _on_tick() -> void:
	TimeManager.CURRENT_TIME += 1
	
	if TimeManager.CURRENT_TIME >= 1440:
		TimeManager.CURRENT_TIME = 0
		
		if !PlayerData.GAME_STATE == "SLEEPING":
			TimeManager.CURRENT_DAY = int(TimeManager.CURRENT_DAY + 1)
	
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

func change_sky(SkyType: String, TOD : int):
	if transitioning_weather:
		return
	
	if SkyType == "CLOUDY":
		
		transitioning_weather = true
		
		DayNightCycle_Sky.play(&"cloudy_sky_cycle")
		DayNightCycle_Sky.seek(TOD * 2)
		
		DayNightCycle.play(&"cloudy_cycle")
		DayNightCycle.seek(TOD * 2)
		
		await get_tree().create_timer(30.0).timeout
		transitioning_weather = false
	
	if SkyType == "LIGHT_RAIN":
		transitioning_weather = true
		
		DayNightCycle_Sky.play(&"light_rain_sky_cycle")
		DayNightCycle_Sky.seek(TOD * 2)
		
		DayNightCycle.play(&"light_rain_cycle")
		DayNightCycle.seek(TOD * 2)
		
		await get_tree().create_timer(30.0).timeout
		transitioning_weather = false

func change_weather(GOTO_WEATHER_STR : String, ARR_INDEX : int):
	print_rich("[color=pink]Changing weather to: " + GOTO_WEATHER_STR + "[/color]")
	
	if GOTO_WEATHER_STR == "SUNNY":
		# Implement SUNNY weather change logic
		pass
	
	elif GOTO_WEATHER_STR == "CLOUDY":
		# Implement CLOUDY weather change logic
		pass
	
	elif GOTO_WEATHER_STR == "RAIN":
		$Rain.emitting = true
		$Rain.amount = 5000
		$Rain.visible = true
		var tween = get_tree().create_tween()
		tween.tween_property($Rain, "color", Color(1, 1, 1, 1), 30.0).from(Color(1, 1, 1, 0))
		change_sky("CLOUDY", TimeManager.CURRENT_TIME)
		
	elif GOTO_WEATHER_STR == "LIGHT_RAIN":
		$Rain.emitting = true
		$Rain.amount = 2500
		$Rain.visible = true
		var tween = get_tree().create_tween()
		tween.tween_property($Rain, "color", Color(1, 1, 1, 1), 30.0).from(Color(1, 1, 1, 0))
		change_sky("LIGHT_RAIN", TimeManager.CURRENT_TIME)
	
	elif GOTO_WEATHER_STR == "STORM":
		# Implement STORM weather change logic
		pass
	
	WeatherManager.CURRENT_WEATHER = WeatherManager.WEATHERS[ARR_INDEX]
	WeatherManager.CURRENT_WEATHER_ARR_INDEX = ARR_INDEX

func _on_weather_timer_timeout() -> void:
	init_weather()

func init_weather():
	WeatherManager.change_weather_to_random()
	$"Weather Timer".stop()
	$"Weather Timer".wait_time = randi_range(400, 1000)
	$"Weather Timer".start()
