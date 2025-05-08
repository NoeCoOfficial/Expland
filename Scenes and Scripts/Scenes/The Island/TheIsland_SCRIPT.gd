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
@export var Weather_Timer : Timer
@export var RainParticles : CPUParticles3D
@export var Clouds : MeshInstance3D
@export var Player : CharacterBody3D

@export var Building_Assets_Parent : Node

@export_group("Markers")
@export var Marker_StoryModeStartSpawn : Marker3D

var transitioning_weather = false

func _ready() -> void:
	PlayerManager.WORLD = $"."
	BuildingManager.Building_Assets_Parent = Building_Assets_Parent
	randomize()
	initNodes()
	
	TerrainManager.on_terrain = "GRASS"
	AudioManager.NotificationOnScreen = false
	AudioManager.canOperate_textField = true
	IslandManager.transitioning_from_menu = false
	Global.main_menu_transitioning_scene = false
	Global.transitioning_to_main_menu_from_island = false
	Global.is_in_main_menu = false
	
	set_pretty_shadows(PlayerSettingsData.PrettyShadows)
	
	if PlayerData.GAME_STATE == "SLEEPING":
		PlayerData.GAME_STATE = "NORMAL"
		set_time(360)
	else:
		set_time(TimeManager.CURRENT_TIME)
	
	Tick.start()
	
	if IslandManager.Current_Game_Mode == "STORY":
		init_weather_instant_custom(0)
	else:
		init_weather_instant() # NOTE: Important line right here (initalize weather)
		Player.camera.make_current()
	
	if IslandManager.Current_Game_Mode == "STORY" and StoryModeManager.is_first_story_mode:
		# NOTE: Story mode init. What happens when the player spawns in for the first time.
		Player.global_position = Marker_StoryModeStartSpawn.global_position
		$"Story Mode/Animation Players/StoryModeWakeUpAnimation".play("main")
		PlayerManager.is_in_cutscene = true
		Player.init_for_cutscene()
		Player.hide()
		set_time(1140)
		$"Story Mode/Canvas Layers/MinimalDialogueLayer/MinimalDialogue".spawnMinimalDialogue(DialogueManager.StoryMode_Dialogue1)
	
	Player.nodeSetup()

func _on_ready() -> void:
	AudioManager.initNotificaton(PlayerManager.AudioNotification)
	AudioManager.initNew($TheIsland_Audio, !StoryModeManager.is_first_story_mode, false, true)
	AudioManager.Current_Rain_SFX_Node = $Rain_SFX

func _process(_delta: float) -> void:
	RainParticles.position.x = Player.position.x
	RainParticles.position.z = Player.position.z
	WeatherManager.WEATHER_TIMER_TIME_LEFT = int(Weather_Timer.time_left)

func initNodes():
	RainParticles.emitting = false
	RainParticles.visible = false
	$"Story Mode/Canvas Layers/EyeBlinkLayer/BottomBlink".position = Vector2(0.0, 688.0)
	$"Story Mode/Canvas Layers/EyeBlinkLayer/TopBlink".position = Vector2(1152.0, -39.0)

func set_pretty_shadows(value : bool) -> void:
	if value:
		IslandManager.IslandWorldEnv.sdfgi_enabled = true
	else:
		IslandManager.IslandWorldEnv.sdfgi_enabled = false

func set_time(minute : int):
	
	# Transitioning sky depending on the current weather
	# Blend time is instant (0.0)
	
	if WeatherManager.CURRENT_WEATHER == "SUNNY":
	
		if !DayNightCycle.is_playing():
			DayNightCycle.play(&"cycle", 0.0)
		else:
			DayNightCycle.stop()
			DayNightCycle.play(&"cycle", 0.0)
		
		if DayNightCycle_Sky.is_playing():
			DayNightCycle_Sky.play(&"sky_cycle", 0.0)
		else:
			DayNightCycle_Sky.stop()
			DayNightCycle_Sky.play(&"sky_cycle", 0.0)
	
	if WeatherManager.CURRENT_WEATHER == "CLOUDY" or WeatherManager.CURRENT_WEATHER == "LIGHT_RAIN":
		
		if !DayNightCycle.is_playing():
			DayNightCycle.play(&"light_rain_cycle", 0.0)
		else:
			DayNightCycle.stop()
			DayNightCycle.play(&"light_rain_cycle", 0.0)
		
		if DayNightCycle_Sky.is_playing():
			DayNightCycle_Sky.play(&"light_rain_sky_cycle", 0.0)
		else:
			DayNightCycle_Sky.stop()
			DayNightCycle_Sky.play(&"light_rain_sky_cycle", 0.0)
	
	if WeatherManager.CURRENT_WEATHER == "STORM" or WeatherManager.CURRENT_WEATHER == "RAIN":
		
		if !DayNightCycle.is_playing():
			DayNightCycle.play(&"cloudy_cycle", 0.0)
		else:
			DayNightCycle.stop()
			DayNightCycle.play(&"cloudy_cycle", 0.0)
		
		if DayNightCycle_Sky.is_playing():
			DayNightCycle_Sky.play(&"cloudy_sky_cycle", 0.0)
		else:
			DayNightCycle_Sky.stop()
			DayNightCycle_Sky.play(&"cloudy_sky_cycle", 0.0)
	
	if DayNightCycle_Rotation.is_playing():
		DayNightCycle_Rotation.play(&"rotation_cycle", 0.0)
	else:
		DayNightCycle_Rotation.stop()
		DayNightCycle_Rotation.play(&"rotation_cycle", 0.0)
	
	
	# Minute logic
	
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


## WEATHER


func change_sky(SkyType: String, TOD : int):
	if transitioning_weather:
		print("Already transitioning sky. Can't preform desired operation.")
		return
	
	if SkyType == "SUNNY":
		
		transitioning_weather = true
		
		DayNightCycle_Sky.play(&"sky_cycle")
		DayNightCycle_Sky.seek(TOD * 2)
		
		DayNightCycle.play(&"cycle")
		DayNightCycle.seek(TOD * 2)
		
		await get_tree().create_timer(30.0).timeout
		transitioning_weather = false
	
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

#######################################################################
#######################################################################
#######################################################################

func change_sky_instant(SkyType: String, TOD : int):
	if transitioning_weather:
		print("Already transitioning sky. Can't preform desired operation.")
		return
	
	if SkyType == "SUNNY":
		
		DayNightCycle_Sky.play(&"sky_cycle", 0.0)
		DayNightCycle_Sky.seek(TOD * 2)
		
		DayNightCycle.play(&"cycle", 0.0)
		DayNightCycle.seek(TOD * 2)
		
	
	if SkyType == "CLOUDY":
		
		DayNightCycle_Sky.play(&"cloudy_sky_cycle", 0.0)
		DayNightCycle_Sky.seek(TOD * 2)
		
		DayNightCycle.play(&"cloudy_cycle", 0.0)
		DayNightCycle.seek(TOD * 2)
		
	
	if SkyType == "LIGHT_RAIN":
		
		DayNightCycle_Sky.play(&"light_rain_sky_cycle", 0.0)
		DayNightCycle_Sky.seek(TOD * 2)
		
		DayNightCycle.play(&"light_rain_cycle", 0.0)
		DayNightCycle.seek(TOD * 2)



func change_weather(GOTO_WEATHER_STR : String, PREVIOUS_WEATHER_STR : String):
	print_rich("[color=pink]Changing weather to: " + GOTO_WEATHER_STR + "[/color]")
	
	if GOTO_WEATHER_STR == "SUNNY":
		var tween = get_tree().create_tween()
		tween.connect("finished", _on_rain_color_fade_out_finished)
		tween.tween_property($Rain, "color", Color(1, 1, 1, 0), 20.0)
		change_sky("SUNNY", TimeManager.CURRENT_TIME)
		$Rain_SFX.stop_rain_loop(30.0)
	
	elif GOTO_WEATHER_STR == "CLOUDY":
		var tween = get_tree().create_tween()
		tween.connect("finished", _on_rain_color_fade_out_finished)
		tween.tween_property($Rain, "color", Color(1, 1, 1, 0), 20.0)
		change_sky("LIGHT_RAIN", TimeManager.CURRENT_TIME)
		$Rain_SFX.stop_rain_loop(30.0)
	
	elif GOTO_WEATHER_STR == "RAIN":
		if PREVIOUS_WEATHER_STR != "RAIN":
			if PREVIOUS_WEATHER_STR != "STORM" and PREVIOUS_WEATHER_STR != "LIGHT_RAIN":
				$Rain.amount = 5000
				$Rain.emitting = true
				$Rain.visible = true
				var tween = get_tree().create_tween()
				tween.tween_property($Rain, "color", Color(1, 1, 1, 1), 20.0).from(Color(1, 1, 1, 0))
				change_sky("CLOUDY", TimeManager.CURRENT_TIME)
			
			if PREVIOUS_WEATHER_STR == "LIGHT_RAIN":
				$Rain_SFX.tween_fade(30.0, -7.0)
				
			if PREVIOUS_WEATHER_STR != "STORM" and PREVIOUS_WEATHER_STR != "LIGHT_RAIN":
				$Rain_SFX.start_rain_loop(30.0, -7.0)
				
		
	elif GOTO_WEATHER_STR == "LIGHT_RAIN":
		if PREVIOUS_WEATHER_STR != "LIGHT_RAIN":
			if PREVIOUS_WEATHER_STR != "STORM" and PREVIOUS_WEATHER_STR != "RAIN":
				$Rain.amount = 2500
				$Rain.emitting = true
				
				$Rain.visible = true
				var tween = get_tree().create_tween()
				tween.tween_property($Rain, "color", Color(1, 1, 1, 1), 20.0).from(Color(1, 1, 1, 0))
				change_sky("LIGHT_RAIN", TimeManager.CURRENT_TIME)
				
			if PREVIOUS_WEATHER_STR == "STORM" or PREVIOUS_WEATHER_STR == "RAIN":
				$Rain_SFX.tween_fade(30.0, -13.0)
			
			else:
				$Rain_SFX.start_rain_loop(30.0, -13.0)
		
	elif GOTO_WEATHER_STR == "STORM":
		# Implement STORM weather change logic
		pass


func change_weather_instant(GOTO_WEATHER_STR : String, PREVIOUS_WEATHER_STR : String):
	print_rich("[color=pink]Changing weather to: " + GOTO_WEATHER_STR + "[/color]")
	print_rich("[color=red]WARNING: Weather change is instant[/color]")
	
	if GOTO_WEATHER_STR == "SUNNY":
		$Rain.color = Color(1, 1, 1, 0)
		change_sky_instant("SUNNY", TimeManager.CURRENT_TIME)
		$Rain_SFX.stop_rain_loop(0.0)
	
	elif GOTO_WEATHER_STR == "CLOUDY":
		$Rain.color = Color(1, 1, 1, 0)
		change_sky_instant("LIGHT_RAIN", TimeManager.CURRENT_TIME)
		$Rain_SFX.stop_rain_loop(0.0)
		
	
	elif GOTO_WEATHER_STR == "RAIN":
		if PREVIOUS_WEATHER_STR != "RAIN":
			
			if PREVIOUS_WEATHER_STR != "STORM" and PREVIOUS_WEATHER_STR != "LIGHT_RAIN":
				$Rain.amount = 5000
				$Rain.emitting = true
			
			
			if PREVIOUS_WEATHER_STR == "LIGHT_RAIN":
				$Rain_SFX.tween_fade(3.0, -7.0)
				
			if PREVIOUS_WEATHER_STR != "STORM" and PREVIOUS_WEATHER_STR != "LIGHT_RAIN":
				$Rain_SFX.start_rain_loop(3.0, -7.0)
			
			$Rain.visible = true
			$Rain.visible = true
			$Rain.color = Color(1, 1, 1, 1)
			change_sky_instant("CLOUDY", TimeManager.CURRENT_TIME)
		
		
	elif GOTO_WEATHER_STR == "LIGHT_RAIN":
		if PREVIOUS_WEATHER_STR != "LIGHT_RAIN":
			
			
			if PREVIOUS_WEATHER_STR != "STORM" and PREVIOUS_WEATHER_STR != "RAIN":
				$Rain.amount = 2500
				$Rain.emitting = true
			
			
			if PREVIOUS_WEATHER_STR == "STORM" or PREVIOUS_WEATHER_STR == "RAIN":
				$Rain_SFX.tween_fade(3.0, -13.0)
			
			else:
				$Rain_SFX.start_rain_loop(3.0, -13.0)
			
			$Rain.visible = true
			$Rain.color = Color(1, 1, 1, 1)
			change_sky_instant("LIGHT_RAIN", TimeManager.CURRENT_TIME)
		
	
	elif GOTO_WEATHER_STR == "STORM":
		# Implement STORM weather change logic
		pass


func _on_rain_color_fade_out_finished():
	$Rain.emitting = false

func _on_weather_timer_timeout() -> void:
	init_weather_with_fade()

func init_weather_with_fade():
	WeatherManager.change_weather_to_random()
	$"Weather Timer".stop()
	#$"Weather Timer".wait_time = randi_range(400, 1000)
	$"Weather Timer".start()

func init_weather_instant():
	WeatherManager.change_weather_to_random_instant()
	$"Weather Timer".stop()
	#$"Weather Timer".wait_time = randi_range(400, 1000)
	$"Weather Timer".start()

func init_weather_instant_custom(ARR_INDEX : int):
	WeatherManager.change_weather_instant(ARR_INDEX)
	$"Weather Timer".stop()
	$"Weather Timer".wait_time = 600
	$"Weather Timer".start()

#####################################

func _on_item_workshop_test_action_triggered() -> void:
	PlayerManager.PLAYER.openItemWorkshop()

func _on_test_dialogue_start_action_triggered() -> void:
	DialogueManager.startDialogue(DialogueManager.testDialogue)

func _on_email_noe_co_action_triggered() -> void:
	OS.shell_open("https://mail.google.com/mail/?view=cm&fs=1&to=noeco.official@gmail.com")

func _on_open_feedback_issue_action_triggered() -> void:
	OS.shell_open("https://github.com/NoeCoOfficial/Expland/issues/new?assignees=&labels=&projects=&template=feedback.md")

#####################################

func playBlinkEffect():
	$"Story Mode/Canvas Layers/EyeBlinkLayer/BlinkAnimation".play("main")

func makePlayerCameraCurrent():
	$"Story Mode/Cameras/StoryModeWakeUpCamera".clear_current(true)

func firstInitStoryModePlayer():
	Player.show()
	Player.head.rotation_degrees.y = 0.0
	Player.camera.rotation_degrees.x = 0.0

func _on_story_mode_dialogue_2_after_wake_up_timer_timeout() -> void:
	if StoryModeManager.is_first_story_mode:
		DialogueManager.setStoryModeID(3)
		DialogueManager.startDialogue(DialogueManager.StoryMode_Dialogue2)


func _on_dialogue_interface_finished_dialogue(StoryModeID: int) -> void:
	if StoryModeID == 3:
		pass
