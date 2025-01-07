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

var HOUR_LENGTH = 10.0
var SKY_TRANS_TIME = 1.0

@onready var TheIslandEnvironment = preload("res://Resources/Environment/TheIslandWorldEnvironment.tres")
@onready var TheIslandProceduralSkyMaterial = preload("res://Resources/Environment/TheIslandProceduralSkyMaterial.tres")
@onready var CloudsShaderMaterial = preload("res://Resources/Materials/CloudsMaterial.tres")

@export var HourTimer : Timer

@export var IslandDirectionalLight : DirectionalLight3D
@export var IslandWorldEnvironmentNode : WorldEnvironment

@export var RainParticles : CPUParticles3D
@export var Clouds : MeshInstance3D

@export var Player : CharacterBody3D

@export var RockPosRef : Node3D
@export var RedFlowerPosRef : Node3D
@export var BlueFlowerPosRef : Node3D
@export var PinkFlowerPosRef : Node3D
@export var BlankFlowerPosRef : Node3D
@export var PickaxePosRef : Node3D
@export var HealthPotionPosRef : Node3D

var hour4_tween
var hour5_tween
var hour7_tween
var hour16_tween
var hour19_tween
var hour21_tween

var transSunny_tween
var transRain_tween
var transStorm_tween
var transCloudy_tween

var sunRotation_tween

var MiddayColor = Color(0.941, 0.987, 0.809)
var SunriseColor = Color(0.793, 0.612, 0.18)
var SunsetColor = Color(0.98, 0.729, 0.312)

var NightCloudColor = Color(0, 0, 0)
var DayCloudColor = Color(0.367, 0.367, 0.367)

func _ready() -> void:
	randomize()
	initNodes()
	HourTimer.wait_time = HOUR_LENGTH
	
	IslandManager.transitioning_from_menu = false
	
	PlayerData.loadData(IslandManager.Current_Island_Name, true)
	InventoryData.loadInventory(IslandManager.Current_Island_Name)
	
	PlayerManager.init()
	set_dof_blur(PlayerSettingsData.DOFBlur)
	
	if PlayerData.GAME_STATE == "SLEEPING":
		PlayerData.GAME_STATE = "NORMAL"
		set_hour(6)
	else:
		on_ready_time_check()
	
	InventoryManager.chestNode = $Chest
	change_weather(false)

func _on_ready() -> void:
	pass

func _process(_delta: float) -> void:
	RainParticles.position.x = Player.position.x
	RainParticles.position.z = Player.position.z

func initNodes():
	RainParticles.emitting = false
	RainParticles.visible = false
	TheIslandProceduralSkyMaterial.sky_top_color = Color(0.311, 0.463, 0.682)
	TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.502, 0.641, 0.905)

func set_dof_blur(value : bool) -> void:
	var cameraAttributesResource = load("res://Resources/Environment/DefaultCameraAttributes.tres")
	
	if value:
		cameraAttributesResource.dof_blur_far_enabled = true
	else:
		cameraAttributesResource.dof_blur_far_enabled = false

func _on_pickup_item_spawn_timer_timeout() -> void:
	InventoryManager.create_pickup_object_at_pos(RockPosRef.position, "ROCK")
	InventoryManager.create_pickup_object_at_pos(RedFlowerPosRef.position, "REDFLOWER")
	InventoryManager.create_pickup_object_at_pos(BlueFlowerPosRef.position, "BLUEFLOWER")
	InventoryManager.create_pickup_object_at_pos(PinkFlowerPosRef.position, "PINKFLOWER")
	InventoryManager.create_pickup_object_at_pos(BlankFlowerPosRef.position, "BLANKFLOWER")
	InventoryManager.create_pickup_object_at_pos(PickaxePosRef.position, "PICKAXE")
	InventoryManager.create_pickup_object_at_pos(HealthPotionPosRef.position, "HEALTHPOTION")

func _on_auto_save_timeout() -> void:
	if IslandManager.Current_Game_Mode == "FREE":
		Utils.take_screenshot_in_thread("user://saveData/Free Mode/Islands/" + IslandManager.Current_Island_Name + "/island.png")
		SaveManager.saveAllData()

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
			if TimeManager.CURRENT_HOUR != 18 or TimeManager.CURRENT_HOUR != 4:
				return options[i]
			else:
				return 1

func change_weather_timeout() -> void:
	change_weather(true)

func change_weather(animate : bool) -> void:
	
	var weather = get_weighted_random_weather()
	
	if weather == 1:
		IslandManager.Current_Weather = "SUNNY"
	
	if weather == 2:
		IslandManager.Current_Weather = "RAIN"
	
	if weather == 3:
		IslandManager.Current_Weather = "STORM"
	
	if weather == 4:
		IslandManager.Current_Weather = "CLOUDY"
	
	if animate:
		
		if weather == 1:
			transToWeather("SUNNY")
			print_rich("[color=green]SUNNY[/color]")
		
		elif weather == 2:
			transToWeather("RAIN")
			print_rich("[color=green]RAIN[/color]")
		
		elif weather == 3:
			transToWeather("STORM")
			print_rich("[color=green]STORM[/color]")
		
		elif weather == 4:
			transToWeather("CLOUDY")
			print_rich("[color=green]CLOUDY[/color]")
	
	else:
		if weather == 1:
			gotoWeather("SUNNY")
			print_rich("[color=green]SUNNY[/color]")
		
		elif weather == 2:
			gotoWeather("RAIN")
			print_rich("[color=green]RAIN[/color]")
		
		elif weather == 3:
			gotoWeather("STORM")
			print_rich("[color=green]STORM[/color]")
		
		elif weather == 4:
			gotoWeather("CLOUDY")
			print_rich("[color=green]CLOUDY[/color]")

func gotoWeather(type : String):
	
	if type == "SUNNY":
		RainParticles.visible = false
		RainParticles.emitting = false
	
	elif type == "RAIN":
		RainParticles.visible = true
		RainParticles.emitting = true
		
		# NOTE: Put rain sound logic here
	
	elif type == "STORM":
		RainParticles.visible = true
		RainParticles.emitting = true
		
		# NOTE: Put rain and thunder sound logic here
	
	elif type == "CLOUDY":
		RainParticles.visible = false
		RainParticles.emitting = false

func transToWeather(type : String):
	
	haltAllWeatherTweens()
	
	if type == "SUNNY":
		RainParticles.emitting = false
		await get_tree().create_timer(1).timeout
		RainParticles.visible = false
		
	elif type == "RAIN":
		RainParticles.visible = true
		RainParticles.emitting = true
		
		# NOTE: Put rain sound logic here
	
	elif type == "STORM":
		RainParticles.visible = true
		RainParticles.emitting = true
		
		# NOTE: Put rain and thunder sound logic here
	
	elif type == "CLOUDY":
		RainParticles.emitting = false
		await get_tree().create_timer(1).timeout
		RainParticles.visible = false

func rotateSun(addX : float):
	var currentX = IslandDirectionalLight.rotation_degrees.x
	
	var newX = currentX + addX
	
	sunRotation_tween = get_tree().create_tween()
	sunRotation_tween.tween_property(IslandDirectionalLight, "rotation_degrees:x", newX, HourTimer.wait_time).from(currentX)

func on_ready_time_check():
	
	TimeManager.CURRENT_HOUR += 1
	
	if TimeManager.CURRENT_HOUR == 24:
		TimeManager.CURRENT_HOUR = 0
	
	set_hour(TimeManager.CURRENT_HOUR)

func _on_tick() -> void:
		TimeManager.CURRENT_HOUR += 1
		
		if TimeManager.CURRENT_HOUR > 23:
			TimeManager.CURRENT_HOUR = 0
		
		SaveManager.saveAllData()
		print("Next hour: " + str(TimeManager.CURRENT_HOUR))
		
		
		if TimeManager.CURRENT_HOUR == 1:
			IslandDirectionalLight.visible = false
			IslandDirectionalLight.rotation_degrees.x = 10.0
			
			TimeManager.DAY_STATE = "NIGHT"
			
		if TimeManager.CURRENT_HOUR == 2:
			IslandDirectionalLight.visible = false
			IslandDirectionalLight.rotation_degrees.x = 10.0
			
			TimeManager.DAY_STATE = "NIGHT"
		
		if TimeManager.CURRENT_HOUR == 3:
			IslandDirectionalLight.visible = false
			IslandDirectionalLight.rotation_degrees.x = 10.0
			
			TimeManager.DAY_STATE = "NIGHT"
		
		if TimeManager.CURRENT_HOUR == 4:
			IslandDirectionalLight.visible = false
			IslandDirectionalLight.rotation_degrees.x = 10.0
			
			hour4_tween = get_tree().create_tween().set_parallel()
			
			hour4_tween.tween_property(TheIslandProceduralSkyMaterial, "sky_top_color", Color(0.311, 0.463, 0.682), HourTimer.wait_time * 5.5)
			hour4_tween.tween_property(TheIslandProceduralSkyMaterial, "sky_horizon_color", Color(0.502, 0.641, 0.905), HourTimer.wait_time * 5.5)
			hour4_tween.tween_property(TheIslandProceduralSkyMaterial, "ground_bottom_color", Color(0.2, 0.169, 0.133), HourTimer.wait_time * 5.5)
			hour4_tween.tween_property(TheIslandProceduralSkyMaterial, "ground_horizon_color", Color(0.502, 0.641, 0.905), HourTimer.wait_time * 5.5)
			
			hour4_tween.tween_property(CloudsShaderMaterial, "shader_parameter/cloud_color", DayCloudColor, HourTimer.wait_time)
			
			TimeManager.DAY_STATE = "NIGHT"
			
		
		if TimeManager.CURRENT_HOUR == 5:
			IslandDirectionalLight.visible = true
			IslandDirectionalLight.light_color = SunriseColor
			
			hour5_tween = get_tree().create_tween()
			hour5_tween.tween_property(IslandDirectionalLight, "light_energy", 1, HourTimer.wait_time).from(0)
			
			rotateSun(-32) 
			## -22 deg at finish
			## 10 deg at start
			
			TimeManager.DAY_STATE = "DAY"
		
		if TimeManager.CURRENT_HOUR == 6:
			rotateSun(-15) 
			## -37 deg at finish
			## -22 deg at start
			
			TimeManager.DAY_STATE = "DAY"
		
		if TimeManager.CURRENT_HOUR == 7:
			hour7_tween = get_tree().create_tween()
			hour7_tween.tween_property(IslandDirectionalLight, "light_color", MiddayColor, HourTimer.wait_time)
			rotateSun(-12) 
			## -49 deg at finish
			## -37 deg at start
			
			TimeManager.DAY_STATE = "DAY"
			
		if TimeManager.CURRENT_HOUR == 8:
			rotateSun(-12)
			## -61 deg at finish
			## -49 deg at start
			
			TimeManager.DAY_STATE = "DAY"
		
		if TimeManager.CURRENT_HOUR == 9:
			rotateSun(-9)
			## -70 deg at finish
			## -61 deg at start
			
			TimeManager.DAY_STATE = "DAY"
		
		if TimeManager.CURRENT_HOUR == 10:
			rotateSun(-8)
			## -78 deg at finish
			## -70 deg at start
			
			TimeManager.DAY_STATE = "DAY"
		
		if TimeManager.CURRENT_HOUR == 11:
			rotateSun(-7)
			## -85 deg at finish
			## -78 deg at start
			
			TimeManager.DAY_STATE = "DAY"
	
		if TimeManager.CURRENT_HOUR == 12:
			rotateSun(-8)
			## -93 deg at finish
			## -85 deg at start
			
			TimeManager.DAY_STATE = "DAY"
		
		if TimeManager.CURRENT_HOUR == 13:
			rotateSun(-9)
			## -102 deg at finish
			## -93 deg at start
			
			TimeManager.DAY_STATE = "DAY"
		
		if TimeManager.CURRENT_HOUR == 14:
			rotateSun(-10)
			## -112 deg at finish
			## -102 deg at start
			
			TimeManager.DAY_STATE = "DAY"
		
		if TimeManager.CURRENT_HOUR == 15:
			rotateSun(-12)
			## -124 deg at finish
			## -112 deg at start
			
			TimeManager.DAY_STATE = "DAY"
		
		if TimeManager.CURRENT_HOUR == 16:
			hour16_tween = get_tree().create_tween().set_parallel()
			hour16_tween.tween_property(IslandDirectionalLight, "light_color", SunsetColor, HourTimer.wait_time * 2)
			
			hour16_tween.tween_property(TheIslandProceduralSkyMaterial, "sky_top_color", Color(0.011, 0.011, 0.011), HourTimer.wait_time * 7)
			hour16_tween.tween_property(TheIslandProceduralSkyMaterial, "sky_horizon_color", Color(0.038, 0.038, 0.038), HourTimer.wait_time * 7)
			hour16_tween.tween_property(TheIslandProceduralSkyMaterial, "ground_bottom_color", Color(0, 0, 0), HourTimer.wait_time * 7)
			hour16_tween.tween_property(TheIslandProceduralSkyMaterial, "ground_horizon_color", Color(0, 0, 0), HourTimer.wait_time * 7)
			
			hour16_tween.tween_property(CloudsShaderMaterial, "shader_parameter/cloud_color", NightCloudColor, HourTimer.wait_time * 6)
			
			rotateSun(-15)
			## -139 deg at finish
			## -124 deg at start
			
			TimeManager.DAY_STATE = "DAY"
		
		if TimeManager.CURRENT_HOUR == 17:
			rotateSun(-17)
			## -156 deg at finish
			## -139 deg at start
			
			TimeManager.DAY_STATE = "DAY"
		
		if TimeManager.CURRENT_HOUR == 18:
			rotateSun(-12)
			## -168 deg at finish
			## -156 deg at start
			
			TimeManager.DAY_STATE = "NIGHT"
		
		if TimeManager.CURRENT_HOUR == 19:
			hour19_tween = get_tree().create_tween().set_parallel()
			hour19_tween.tween_property(CloudsShaderMaterial, "shader_parameter/cloud_color", NightCloudColor, HourTimer.wait_time * 2)
			rotateSun(-7)
			## -175 deg at finish
			## -168 deg at start
			
			TimeManager.DAY_STATE = "NIGHT"
		
		if TimeManager.CURRENT_HOUR == 20:
			rotateSun(-7)
			## -182 deg at finish
			## -175 deg at start
			
			TimeManager.DAY_STATE = "NIGHT"
		
		if TimeManager.CURRENT_HOUR == 21:
			hour21_tween = get_tree().create_tween()
			hour21_tween.tween_property(IslandDirectionalLight, "light_energy", 0, HourTimer.wait_time)
			rotateSun(-7)
			## -189 deg at finish
			## -182 deg at start
			
			TimeManager.DAY_STATE = "NIGHT"
		
		if TimeManager.CURRENT_HOUR == 22:
			IslandDirectionalLight.visible = false
			IslandDirectionalLight.rotation_degrees.x = 10.0
			
			TimeManager.DAY_STATE = "NIGHT"
		
		if TimeManager.CURRENT_HOUR == 23:
			IslandDirectionalLight.visible = false
			IslandDirectionalLight.rotation_degrees.x = 10.0
			
			TimeManager.DAY_STATE = "NIGHT"
		
		if TimeManager.CURRENT_HOUR == 0 or TimeManager.CURRENT_HOUR == 24:
			
			IslandDirectionalLight.visible = false
			IslandDirectionalLight.rotation_degrees.x = 10.0
			
			if !PlayerData.GAME_STATE == "SLEEPING":
				TimeManager.CURRENT_DAY += 1
			PlayerData.saveData(IslandManager.Current_Island_Name)
			
			TimeManager.DAY_STATE = "NIGHT"
   
func set_hour(hour : int):
	if hour == 0 or hour == 24:
		TimeManager.CURRENT_HOUR = 0
		HourTimer.wait_time = HOUR_LENGTH
		# Midnight colors
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.011, 0.011, 0.011)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.038, 0.038, 0.038)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0, 0, 0)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0, 0, 0)
		CloudsShaderMaterial.set_shader_parameter(&"cloud_color", NightCloudColor)
		
		IslandDirectionalLight.visible = false
		IslandDirectionalLight.rotation_degrees.x = 10.0
		
		TimeManager.DAY_STATE = "NIGHT"
	
	if hour == 1:
		HourTimer.wait_time = HOUR_LENGTH
		TimeManager.CURRENT_HOUR = 1
		haltAllHourTweens()
		# Midnight colors
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.011, 0.011, 0.011)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.038, 0.038, 0.038)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0, 0, 0)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0, 0, 0)
		CloudsShaderMaterial.set_shader_parameter(&"cloud_color", NightCloudColor)
		
		IslandDirectionalLight.visible = false
		IslandDirectionalLight.rotation_degrees.x = 10.0
		
		TimeManager.DAY_STATE = "NIGHT"
	
	if hour == 2:
		HourTimer.wait_time = HOUR_LENGTH
		TimeManager.CURRENT_HOUR = 2
		haltAllHourTweens()
		# Midnight colors
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.011, 0.011, 0.011)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.038, 0.038, 0.038)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0, 0, 0)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0, 0, 0)
		CloudsShaderMaterial.set_shader_parameter(&"cloud_color", NightCloudColor)
		
		IslandDirectionalLight.visible = false
		IslandDirectionalLight.rotation_degrees.x = 10.0
		
		TimeManager.DAY_STATE = "NIGHT"
	
	if hour == 3:
		HourTimer.wait_time = HOUR_LENGTH
		TimeManager.CURRENT_HOUR = 3
		haltAllHourTweens()
		# Midnight colors
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.011, 0.011, 0.011)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.038, 0.038, 0.038)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0, 0, 0)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0, 0, 0)
		CloudsShaderMaterial.set_shader_parameter(&"cloud_color", NightCloudColor)
		
		IslandDirectionalLight.visible = false
		IslandDirectionalLight.rotation_degrees.x = 10.0
		
		TimeManager.DAY_STATE = "NIGHT"
	
	if hour == 4:
		HourTimer.wait_time = HOUR_LENGTH
		TimeManager.CURRENT_HOUR = 4
		haltAllHourTweens()
		# Midnight colors
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.011, 0.011, 0.011)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.038, 0.038, 0.038)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0, 0, 0)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0, 0, 0)
		CloudsShaderMaterial.set_shader_parameter(&"cloud_color", NightCloudColor)
		
		IslandDirectionalLight.visible = false
		IslandDirectionalLight.rotation_degrees.x = 10.0
		
		var tween = get_tree().create_tween().set_parallel()
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_top_color", Color(0.311, 0.463, 0.682), HourTimer.wait_time * 3.5)
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_horizon_color", Color(0.502, 0.641, 0.905), HourTimer.wait_time * 3.5)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_bottom_color", Color(0.2, 0.169, 0.133), HourTimer.wait_time * 3.5)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_horizon_color", Color(0.502, 0.641, 0.905), HourTimer.wait_time * 3.5)
		tween.tween_property(CloudsShaderMaterial, "shader_parameter/cloud_color", DayCloudColor, HourTimer.wait_time)
		
		TimeManager.DAY_STATE = "NIGHT"

	
	if hour == 5:
		HourTimer.wait_time = HOUR_LENGTH
		TimeManager.CURRENT_HOUR = 5
		haltAllHourTweens()
		# Midnight colors
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.011, 0.011, 0.011)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.038, 0.038, 0.038)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0, 0, 0)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0, 0, 0)
		CloudsShaderMaterial.set_shader_parameter(&"cloud_color", DayCloudColor)
		
		IslandDirectionalLight.rotation_degrees.x = 10
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = SunriseColor
		
		var tween = get_tree().create_tween().set_parallel()
		tween.tween_property(IslandDirectionalLight, "light_energy", 1, HourTimer.wait_time).from(0)
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_top_color", Color(0.311, 0.463, 0.682), HourTimer.wait_time * 2.5)
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_horizon_color", Color(0.502, 0.641, 0.905), HourTimer.wait_time * 2.5)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_bottom_color", Color(0.2, 0.169, 0.133), HourTimer.wait_time * 2.5)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_horizon_color", Color(0.502, 0.641, 0.905), HourTimer.wait_time * 2.5)
		
		rotateSun(-32)
		## End at -22
		
		TimeManager.DAY_STATE = "DAY"
	
	if hour == 6:
		HourTimer.wait_time = HOUR_LENGTH
		TimeManager.CURRENT_HOUR = 6
		haltAllHourTweens()
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.22, 0.347, 0.53)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.274, 0.435, 0.754)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.117, 0.096, 0.072)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.221, 0.369, 0.665)
		CloudsShaderMaterial.set_shader_parameter(&"cloud_color", DayCloudColor)
		
		IslandDirectionalLight.rotation_degrees.x = -22
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = SunriseColor
		
		var tween = get_tree().create_tween().set_parallel()
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_top_color", Color(0.311, 0.463, 0.682), HourTimer.wait_time * 1.5)
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_horizon_color", Color(0.502, 0.641, 0.905), HourTimer.wait_time * 1.5)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_bottom_color", Color(0.2, 0.169, 0.133), HourTimer.wait_time * 1.5)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_horizon_color", Color(0.502, 0.641, 0.905), HourTimer.wait_time * 1.5)
		 
		rotateSun(-15)
		## End at -37
		
		TimeManager.DAY_STATE = "DAY"
	
	if hour == 7:
		HourTimer.wait_time = HOUR_LENGTH
		TimeManager.CURRENT_HOUR = 7
		haltAllHourTweens()
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.311, 0.463, 0.682)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.274, 0.435, 0.754)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.502, 0.641, 0.905)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.502, 0.641, 0.905)
		CloudsShaderMaterial.set_shader_parameter(&"cloud_color", DayCloudColor)
		
		IslandDirectionalLight.rotation_degrees.x = -37
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = SunriseColor
		var tween = get_tree().create_tween()
		tween.tween_property(IslandDirectionalLight, "light_color", MiddayColor, HourTimer.wait_time)
		
		rotateSun(-12) 
		## End at -49
		
		TimeManager.DAY_STATE = "DAY"
	
	if hour == 8:
		HourTimer.wait_time = HOUR_LENGTH
		TimeManager.CURRENT_HOUR = 8
		haltAllHourTweens()
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.311, 0.463, 0.682)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.274, 0.435, 0.754)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.502, 0.641, 0.905)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.502, 0.641, 0.905)
		CloudsShaderMaterial.set_shader_parameter(&"cloud_color", DayCloudColor)
		
		IslandDirectionalLight.rotation_degrees.x = -49
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = MiddayColor
		
		rotateSun(-12)
		## End at -61
		
		TimeManager.DAY_STATE = "DAY"
	
	if hour == 9:
		HourTimer.wait_time = HOUR_LENGTH
		TimeManager.CURRENT_HOUR = 9
		haltAllHourTweens()
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.311, 0.463, 0.682)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.274, 0.435, 0.754)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.502, 0.641, 0.905)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.502, 0.641, 0.905)
		CloudsShaderMaterial.set_shader_parameter(&"cloud_color", DayCloudColor)
		
		IslandDirectionalLight.rotation_degrees.x = -61
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = MiddayColor
		
		rotateSun(-9)
		## End at -70
		
		TimeManager.DAY_STATE = "DAY"
	
	if hour == 10:
		HourTimer.wait_time = HOUR_LENGTH
		TimeManager.CURRENT_HOUR = 10
		haltAllHourTweens()
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.311, 0.463, 0.682)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.274, 0.435, 0.754)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.502, 0.641, 0.905)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.502, 0.641, 0.905)
		CloudsShaderMaterial.set_shader_parameter(&"cloud_color", DayCloudColor)
		
		IslandDirectionalLight.rotation_degrees.x = -70
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = MiddayColor
		
		rotateSun(-8)
		## End at -78
		
		TimeManager.DAY_STATE = "DAY"
	
	if hour == 11:
		HourTimer.wait_time = HOUR_LENGTH
		TimeManager.CURRENT_HOUR = 11
		haltAllHourTweens()
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.311, 0.463, 0.682)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.274, 0.435, 0.754)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.502, 0.641, 0.905)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.502, 0.641, 0.905)
		CloudsShaderMaterial.set_shader_parameter(&"cloud_color", DayCloudColor)
		
		IslandDirectionalLight.rotation_degrees.x = -78
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = MiddayColor
		
		rotateSun(-7)
		## End at -85
		
		TimeManager.DAY_STATE = "DAY"
	
	if hour == 12:
		HourTimer.wait_time = HOUR_LENGTH
		TimeManager.CURRENT_HOUR = 12
		haltAllHourTweens()
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.311, 0.463, 0.682)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.274, 0.435, 0.754)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.502, 0.641, 0.905)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.502, 0.641, 0.905)
		CloudsShaderMaterial.set_shader_parameter(&"cloud_color", DayCloudColor)
		
		IslandDirectionalLight.rotation_degrees.x = -85
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = MiddayColor
		
		rotateSun(-8)
		## End at -93
		
		TimeManager.DAY_STATE = "DAY"
	
	if hour == 13:
		HourTimer.wait_time = HOUR_LENGTH
		TimeManager.CURRENT_HOUR = 13
		haltAllHourTweens()
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.311, 0.463, 0.682)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.274, 0.435, 0.754)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.502, 0.641, 0.905)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.502, 0.641, 0.905)
		CloudsShaderMaterial.set_shader_parameter(&"cloud_color", DayCloudColor)
		
		IslandDirectionalLight.rotation_degrees.x = -93
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = MiddayColor
		
		rotateSun(-9)
		## End at -102
		
		TimeManager.DAY_STATE = "DAY"
	
	if hour == 14:
		HourTimer.wait_time = HOUR_LENGTH
		TimeManager.CURRENT_HOUR = 14
		haltAllHourTweens()
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.311, 0.463, 0.682)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.274, 0.435, 0.754)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.502, 0.641, 0.905)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.502, 0.641, 0.905)
		CloudsShaderMaterial.set_shader_parameter(&"cloud_color", DayCloudColor)
		
		IslandDirectionalLight.rotation_degrees.x = -102
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = MiddayColor
		
		rotateSun(-10)
		## End at -112
		
		TimeManager.DAY_STATE = "DAY"
	
	if hour == 15:
		HourTimer.wait_time = HOUR_LENGTH
		TimeManager.CURRENT_HOUR = 15
		haltAllHourTweens()
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.311, 0.463, 0.682)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.274, 0.435, 0.754)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.502, 0.641, 0.905)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.502, 0.641, 0.905)
		CloudsShaderMaterial.set_shader_parameter(&"cloud_color", DayCloudColor)
		
		IslandDirectionalLight.rotation_degrees.x = -112
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = MiddayColor
		
		rotateSun(-12)
		## End at -124
		
		TimeManager.DAY_STATE = "DAY"
	
	if hour == 16:
		HourTimer.wait_time = HOUR_LENGTH
		TimeManager.CURRENT_HOUR = 16
		haltAllHourTweens()
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.311, 0.463, 0.682)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.274, 0.435, 0.754)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.502, 0.641, 0.905)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.502, 0.641, 0.905)
		CloudsShaderMaterial.set_shader_parameter(&"cloud_color", DayCloudColor)
		
		IslandDirectionalLight.rotation_degrees.x = -124
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = MiddayColor
		
		var tween = get_tree().create_tween().set_parallel()
		tween.tween_property(IslandDirectionalLight, "light_color", SunsetColor, HourTimer.wait_time * 2)
		
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_top_color", Color(0.011, 0.011, 0.011), HourTimer.wait_time * 7)
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_horizon_color", Color(0.038, 0.038, 0.038), HourTimer.wait_time * 7)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_bottom_color", Color(0, 0, 0), HourTimer.wait_time * 7)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_horizon_color", Color(0, 0, 0), HourTimer.wait_time * 7)
		
		rotateSun(-15)
		## End at -139
		
		TimeManager.DAY_STATE = "DAY"
	
	if hour == 17:
		HourTimer.wait_time = HOUR_LENGTH
		TimeManager.CURRENT_HOUR = 17
		haltAllHourTweens()
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.245, 0.381, 0.577)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.229, 0.38, 0.682)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.325, 0.488, 0.809)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.325, 0.488, 0.809)
		CloudsShaderMaterial.set_shader_parameter(&"cloud_color", DayCloudColor)
		
		IslandDirectionalLight.rotation_degrees.x = -139
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = SunsetColor
		
		var tween = get_tree().create_tween().set_parallel()
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_top_color", Color(0.011, 0.011, 0.011), HourTimer.wait_time * 6)
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_horizon_color", Color(0.038, 0.038, 0.038), HourTimer.wait_time * 6)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_bottom_color", Color(0, 0, 0), HourTimer.wait_time * 6)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_horizon_color", Color(0, 0, 0), HourTimer.wait_time * 6)
		
		rotateSun(-17)
		## End at -156
		
		TimeManager.DAY_STATE = "DAY"
	
	if hour == 18:
		HourTimer.wait_time = HOUR_LENGTH
		TimeManager.CURRENT_HOUR = 18
		haltAllHourTweens()
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.195, 0.313, 0.483)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.184, 0.317, 0.585)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.248, 0.403, 0.714)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.236, 0.388, 0.693)
		CloudsShaderMaterial.set_shader_parameter(&"cloud_color", DayCloudColor)
		
		IslandDirectionalLight.rotation_degrees.x = -156
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = SunsetColor
		
		var tween = get_tree().create_tween().set_parallel()
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_top_color", Color(0.011, 0.011, 0.011), HourTimer.wait_time * 5)
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_horizon_color", Color(0.038, 0.038, 0.038), HourTimer.wait_time * 5)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_bottom_color", Color(0, 0, 0), HourTimer.wait_time * 5)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_horizon_color", Color(0, 0, 0), HourTimer.wait_time * 5)
		
		rotateSun(-12)
		## End at -168
		
		TimeManager.DAY_STATE = "NIGHT"
	
	if hour == 19:
		HourTimer.wait_time = HOUR_LENGTH
		TimeManager.CURRENT_HOUR = 19
		haltAllHourTweens()
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.151, 0.25, 0.393)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.152, 0.27, 0.508)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.177, 0.306, 0.567)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.155, 0.274, 0.513)
		CloudsShaderMaterial.set_shader_parameter(&"cloud_color", DayCloudColor)
		
		IslandDirectionalLight.rotation_degrees.x = -168
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = SunsetColor
		
		var tween = get_tree().create_tween().set_parallel()
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_top_color", Color(0.011, 0.011, 0.011), HourTimer.wait_time * 4)
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_horizon_color", Color(0.038, 0.038, 0.038), HourTimer.wait_time * 4)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_bottom_color", Color(0, 0, 0), HourTimer.wait_time * 4)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_horizon_color", Color(0, 0, 0), HourTimer.wait_time * 4)
		tween.tween_property(CloudsShaderMaterial, "shader_parameter/cloud_color", NightCloudColor, HourTimer.wait_time * 2)
		
		rotateSun(-7)
		## -175 deg at finish
		
		TimeManager.DAY_STATE = "NIGHT"
	
	if hour == 20:
		HourTimer.wait_time = HOUR_LENGTH
		TimeManager.CURRENT_HOUR = 20
		haltAllHourTweens()
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.109, 0.189, 0.304)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.12, 0.221, 0.424)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.129, 0.235, 0.448)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.113, 0.21, 0.405)
		CloudsShaderMaterial.set_shader_parameter(&"cloud_color", NightCloudColor)
		
		IslandDirectionalLight.rotation_degrees.x = -175
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = SunsetColor
		
		var tween = get_tree().create_tween().set_parallel()
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_top_color", Color(0.011, 0.011, 0.011), HourTimer.wait_time * 3)
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_horizon_color", Color(0.038, 0.038, 0.038), HourTimer.wait_time * 3)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_bottom_color", Color(0, 0, 0), HourTimer.wait_time * 3)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_horizon_color", Color(0, 0, 0), HourTimer.wait_time * 3)
		
		rotateSun(-7)
		## End at -182
		
		TimeManager.DAY_STATE = "NIGHT"
	
	if hour == 21:
		HourTimer.wait_time = HOUR_LENGTH
		TimeManager.CURRENT_HOUR = 21
		haltAllHourTweens()
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.065, 0.123, 0.208)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.066, 0.137, 0.28)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.053, 0.116, 0.243)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.071, 0.144, 0.292)
		CloudsShaderMaterial.set_shader_parameter(&"cloud_color", NightCloudColor)
		
		IslandDirectionalLight.rotation_degrees.x = -182
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = SunsetColor
		
		var tween = get_tree().create_tween().set_parallel()
		tween.tween_property(IslandDirectionalLight, "light_energy", 0, HourTimer.wait_time)
		
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_top_color", Color(0.011, 0.011, 0.011), HourTimer.wait_time * 2)
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_horizon_color", Color(0.038, 0.038, 0.038), HourTimer.wait_time * 2)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_bottom_color", Color(0, 0, 0), HourTimer.wait_time * 2)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_horizon_color", Color(0, 0, 0), HourTimer.wait_time * 2)
		
		rotateSun(-7)
		## End at -189
		
		TimeManager.DAY_STATE = "NIGHT"
	
	if hour == 22:
		HourTimer.wait_time = HOUR_LENGTH
		TimeManager.CURRENT_HOUR = 22
		haltAllHourTweens()
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.042, 0.089, 0.158)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.033, 0.084, 0.187)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.035, 0.087, 0.193)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.031, 0.08, 0.18)
		CloudsShaderMaterial.set_shader_parameter(&"cloud_color", NightCloudColor)
		
		IslandDirectionalLight.visible = false
		IslandDirectionalLight.rotation_degrees.x = 10.0
		
		var tween = get_tree().create_tween().set_parallel()
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_top_color", Color(0.011, 0.011, 0.011), HourTimer.wait_time)
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_horizon_color", Color(0.038, 0.038, 0.038), HourTimer.wait_time)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_bottom_color", Color(0, 0, 0), HourTimer.wait_time)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_horizon_color", Color(0, 0, 0), HourTimer.wait_time)
		
		TimeManager.DAY_STATE = "NIGHT"
	
	if hour == 23:
		HourTimer.wait_time = HOUR_LENGTH
		TimeManager.CURRENT_HOUR = 23
		haltAllHourTweens()
		# Midnight colors
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.011, 0.011, 0.011)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.038, 0.038, 0.038)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0, 0, 0)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0, 0, 0)
		CloudsShaderMaterial.set_shader_parameter(&"cloud_color", NightCloudColor)
		
		IslandDirectionalLight.visible = false
		IslandDirectionalLight.rotation_degrees.x = 10.0
		
		TimeManager.DAY_STATE = "NIGHT"
	
	PlayerData.saveData(IslandManager.Current_Island_Name)

func haltAllHourTweens():
	
	if hour4_tween:
		hour4_tween.stop()
		hour4_tween.kill()
	
	if hour5_tween:
		hour5_tween.stop()
		hour5_tween.kill()
	
	if hour7_tween:
		hour7_tween.stop()
		hour7_tween.kill()
	
	if hour16_tween:
		hour16_tween.stop()
		hour16_tween.kill()
	
	if hour19_tween:
		hour19_tween.stop()
		hour19_tween.kill()
	
	if hour21_tween:
		hour21_tween.stop()
		hour21_tween.kill()
	
	if sunRotation_tween:
		sunRotation_tween.stop()
		sunRotation_tween.kill()

func haltAllWeatherTweens():
	
	if transSunny_tween:
		transSunny_tween.stop()
		transSunny_tween.kill()
		
	if transRain_tween:
		transRain_tween.stop()
		transRain_tween.kill()
	
	if transStorm_tween:
		transStorm_tween.stop()
		transStorm_tween.kill()
	
	if transCloudy_tween:
		transCloudy_tween.stop()
		transCloudy_tween.kill()

"""
Hours of sunlight rotation values

20: at -180 (-7)
19: at -173 (-12)
18: at -161 (-17)
17: at -144 (-15)
16: at -129 (-12)
15: at -117 (-10)
14: at -107 (-9)
13: at -98 (-8)
12: at -90 (-7)
11: at -83 (-8)
10: at -75 (-9)
9: at -66 (-10)
8: at -56 (-12)
7: at -44 (-15)
6: at -39 (-17)
5: at -22 (-22)
4: at 0

"""
