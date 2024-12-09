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

@onready var motionBlurCompositor = preload("res://Resources/Environment/TheIsland_MotionBlurCompositor.tres")
@onready var noMotionBlurCompositor = preload("res://Resources/Environment/TheIsland_NoMotionBlurCompositor.tres")
@onready var TheIslandEnvironment = preload("res://Resources/Environment/TheIslandWorldEnvironment.tres")
@onready var TheIslandProceduralSkyMaterial = preload("res://Resources/Environment/TheIslandProceduralSkyMaterial.tres")

@export var HourTimer : Timer

@export var IslandDirectionalLight : DirectionalLight3D
@export var IslandWorldEnvironmentNode : WorldEnvironment

var MiddayColor = Color(0.941, 0.987, 0.809)
var SunriseColor = Color(0.793, 0.612, 0.18)
var SunsetColor = Color(0.98, 0.729, 0.312)

@export var RockPosRef : Node3D
@export var RedFlowerPosRef : Node3D
@export var BlueFlowerPosRef : Node3D
@export var PinkFlowerPosRef : Node3D
@export var BlankFlowerPosRef : Node3D
@export var PickaxePosRef : Node3D

func _ready() -> void:
	SaveManager.loadAllData()
	set_motion_blur(PlayerSettingsData.MotionBlur)
	set_dof_blur(PlayerSettingsData.DOFBlur)
	
	on_ready_time_check()
	

func _on_ready() -> void:
	pass

func set_motion_blur(value : bool) -> void:
	if value:
		$WorldEnvironment.set_compositor(motionBlurCompositor)
	else:
		$WorldEnvironment.set_compositor(noMotionBlurCompositor)

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

func rotateSun(addX : float):
	var currentX = IslandDirectionalLight.rotation_degrees.x
	
	var newX = currentX + addX
	
	var tween = get_tree().create_tween()
	tween.tween_property(IslandDirectionalLight, "rotation_degrees:x", newX, HourTimer.wait_time).from(currentX)

func on_ready_time_check():
	TimeManager.CURRENT_HOUR += 1
	
	if TimeManager.CURRENT_HOUR == 24:
		TimeManager.CURRENT_HOUR = 0
	
	if TimeManager.CURRENT_HOUR == 0 or TimeManager.CURRENT_HOUR == 24:
		# Midnight colors
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.011, 0.011, 0.011)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.038, 0.038, 0.038)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0, 0, 0)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0, 0, 0)
		
		IslandDirectionalLight.visible = false
		IslandDirectionalLight.rotation_degrees.x = 10.0
		print("New day")
	
	if TimeManager.CURRENT_HOUR == 1:
		# Midnight colors
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.011, 0.011, 0.011)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.038, 0.038, 0.038)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0, 0, 0)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0, 0, 0)
		
		IslandDirectionalLight.visible = false
		IslandDirectionalLight.rotation_degrees.x = 10.0
	
	if TimeManager.CURRENT_HOUR == 2:
		# Midnight colors
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.011, 0.011, 0.011)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.038, 0.038, 0.038)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0, 0, 0)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0, 0, 0)
		
		IslandDirectionalLight.visible = false
		IslandDirectionalLight.rotation_degrees.x = 10.0
	
	if TimeManager.CURRENT_HOUR == 3:
		# Midnight colors
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.011, 0.011, 0.011)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.038, 0.038, 0.038)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0, 0, 0)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0, 0, 0)
		
		IslandDirectionalLight.visible = false
		IslandDirectionalLight.rotation_degrees.x = 10.0
	
	if TimeManager.CURRENT_HOUR == 4:
		# Midnight colors
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.011, 0.011, 0.011)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.038, 0.038, 0.038)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0, 0, 0)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0, 0, 0)
		
		IslandDirectionalLight.visible = false
		IslandDirectionalLight.rotation_degrees.x = 10.0
	
	if TimeManager.CURRENT_HOUR == 5:
		# Midnight colors
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.011, 0.011, 0.011)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.038, 0.038, 0.038)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0, 0, 0)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0, 0, 0)
		
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
	
	if TimeManager.CURRENT_HOUR == 6:
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.22, 0.347, 0.53)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.274, 0.435, 0.754)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.117, 0.096, 0.072)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.221, 0.369, 0.665)
		
		IslandDirectionalLight.rotation_degrees.x = -22
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = SunriseColor
		rotateSun(-15)
		
		var tween = get_tree().create_tween().set_parallel()
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_top_color", Color(0.311, 0.463, 0.682), HourTimer.wait_time * 1.5)
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_horizon_color", Color(0.502, 0.641, 0.905), HourTimer.wait_time * 1.5)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_bottom_color", Color(0.2, 0.169, 0.133), HourTimer.wait_time * 1.5)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_horizon_color", Color(0.502, 0.641, 0.905), HourTimer.wait_time * 1.5)
		 
		## End at -37
	
	if TimeManager.CURRENT_HOUR == 7:
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.311, 0.463, 0.682)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.274, 0.435, 0.754)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.502, 0.641, 0.905)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.502, 0.641, 0.905)
		
		IslandDirectionalLight.rotation_degrees.x = -37
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = SunriseColor
		var tween = get_tree().create_tween()
		tween.tween_property(IslandDirectionalLight, "light_color", MiddayColor, HourTimer.wait_time * 2)
		rotateSun(-12) 
		## End at -49
	
	if TimeManager.CURRENT_HOUR == 8:
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.311, 0.463, 0.682)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.274, 0.435, 0.754)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.502, 0.641, 0.905)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.502, 0.641, 0.905)
		
		IslandDirectionalLight.rotation_degrees.x = -49
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = MiddayColor
		rotateSun(-12)
		## End at -61
	
	if TimeManager.CURRENT_HOUR == 9:
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.311, 0.463, 0.682)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.274, 0.435, 0.754)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.502, 0.641, 0.905)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.502, 0.641, 0.905)
		
		IslandDirectionalLight.rotation_degrees.x = -61
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = MiddayColor
		rotateSun(-9)
		## End at -70
	
	if TimeManager.CURRENT_HOUR == 10:
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.311, 0.463, 0.682)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.274, 0.435, 0.754)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.502, 0.641, 0.905)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.502, 0.641, 0.905)
		
		IslandDirectionalLight.rotation_degrees.x = -70
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = MiddayColor
		rotateSun(-8)
		## End at -78
	
	if TimeManager.CURRENT_HOUR == 11:
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.311, 0.463, 0.682)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.274, 0.435, 0.754)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.502, 0.641, 0.905)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.502, 0.641, 0.905)
		
		IslandDirectionalLight.rotation_degrees.x = -78
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = MiddayColor
		rotateSun(-7)
		## End at -85
	
	if TimeManager.CURRENT_HOUR == 12:
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.311, 0.463, 0.682)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.274, 0.435, 0.754)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.502, 0.641, 0.905)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.502, 0.641, 0.905)
		
		IslandDirectionalLight.rotation_degrees.x = -85
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = MiddayColor
		rotateSun(-8)
		## End at -93

	if TimeManager.CURRENT_HOUR == 13:
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.311, 0.463, 0.682)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.274, 0.435, 0.754)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.502, 0.641, 0.905)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.502, 0.641, 0.905)
		
		IslandDirectionalLight.rotation_degrees.x = -93
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = MiddayColor
		rotateSun(-9)
		## End at -102
	
	if TimeManager.CURRENT_HOUR == 14:
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.311, 0.463, 0.682)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.274, 0.435, 0.754)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.502, 0.641, 0.905)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.502, 0.641, 0.905)
		
		IslandDirectionalLight.rotation_degrees.x = -102
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = MiddayColor
		rotateSun(-10)
		## End at -112
	
	if TimeManager.CURRENT_HOUR == 15:
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.311, 0.463, 0.682)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.274, 0.435, 0.754)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.502, 0.641, 0.905)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.502, 0.641, 0.905)
		
		IslandDirectionalLight.rotation_degrees.x = -112
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = MiddayColor
		rotateSun(-12)
		## End at -124
	
	if TimeManager.CURRENT_HOUR == 16:
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.311, 0.463, 0.682)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.274, 0.435, 0.754)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.502, 0.641, 0.905)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.502, 0.641, 0.905)
		
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
	
	if TimeManager.CURRENT_HOUR == 17:
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.245, 0.381, 0.577)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.229, 0.38, 0.682)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.325, 0.488, 0.809)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.325, 0.488, 0.809)
		
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
	
	if TimeManager.CURRENT_HOUR == 18:
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.195, 0.313, 0.483)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.184, 0.317, 0.585)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.248, 0.403, 0.714)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.236, 0.388, 0.693)
		
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
	
	if TimeManager.CURRENT_HOUR == 19:
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.151, 0.25, 0.393)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.152, 0.27, 0.508)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.177, 0.306, 0.567)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.155, 0.274, 0.513)
		
		IslandDirectionalLight.rotation_degrees.x = -168
		IslandDirectionalLight.visible = true
		IslandDirectionalLight.light_energy = 1
		IslandDirectionalLight.light_color = SunsetColor
		
		var tween = get_tree().create_tween().set_parallel()
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_top_color", Color(0.011, 0.011, 0.011), HourTimer.wait_time * 4)
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_horizon_color", Color(0.038, 0.038, 0.038), HourTimer.wait_time * 4)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_bottom_color", Color(0, 0, 0), HourTimer.wait_time * 4)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_horizon_color", Color(0, 0, 0), HourTimer.wait_time * 4)
		
		rotateSun(-7)
		## -175 deg at finish
	
	if TimeManager.CURRENT_HOUR == 20:
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.109, 0.189, 0.304)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.12, 0.221, 0.424)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.129, 0.235, 0.448)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.113, 0.21, 0.405)
		
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
	
	if TimeManager.CURRENT_HOUR == 21:
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.065, 0.123, 0.208)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.066, 0.137, 0.28)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.053, 0.116, 0.243)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.071, 0.144, 0.292)
		
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
	
	if TimeManager.CURRENT_HOUR == 22:
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.042, 0.089, 0.158)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.033, 0.084, 0.187)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0.035, 0.087, 0.193)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0.031, 0.08, 0.18)
		
		IslandDirectionalLight.visible = false
		IslandDirectionalLight.rotation_degrees.x = 10.0
		
		var tween = get_tree().create_tween().set_parallel()
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_top_color", Color(0.011, 0.011, 0.011), HourTimer.wait_time)
		tween.tween_property(TheIslandProceduralSkyMaterial, "sky_horizon_color", Color(0.038, 0.038, 0.038), HourTimer.wait_time)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_bottom_color", Color(0, 0, 0), HourTimer.wait_time)
		tween.tween_property(TheIslandProceduralSkyMaterial, "ground_horizon_color", Color(0, 0, 0), HourTimer.wait_time)
	
	if TimeManager.CURRENT_HOUR == 23:
		# Midnight colors
		TheIslandProceduralSkyMaterial.sky_top_color = Color(0.011, 0.011, 0.011)
		TheIslandProceduralSkyMaterial.sky_horizon_color = Color(0.038, 0.038, 0.038)
		TheIslandProceduralSkyMaterial.ground_bottom_color = Color(0, 0, 0)
		TheIslandProceduralSkyMaterial.ground_horizon_color = Color(0, 0, 0)
		
		IslandDirectionalLight.visible = false
		IslandDirectionalLight.rotation_degrees.x = 10.0

func _on_tick() -> void:
		TimeManager.CURRENT_HOUR += 1
		
		if TimeManager.CURRENT_HOUR > 23:
			TimeManager.CURRENT_HOUR = 0
		
		SaveManager.saveAllData()
		print("Next hour: " + str(TimeManager.CURRENT_HOUR))
		
		
		if TimeManager.CURRENT_HOUR == 1:
			IslandDirectionalLight.visible = false
			IslandDirectionalLight.rotation_degrees.x = 10.0
			
		if TimeManager.CURRENT_HOUR == 2:
			IslandDirectionalLight.visible = false
			IslandDirectionalLight.rotation_degrees.x = 10.0
		
		if TimeManager.CURRENT_HOUR == 3:
			IslandDirectionalLight.visible = false
			IslandDirectionalLight.rotation_degrees.x = 10.0
		
		if TimeManager.CURRENT_HOUR == 4:
			IslandDirectionalLight.visible = false
			IslandDirectionalLight.rotation_degrees.x = 10.0
		
		if TimeManager.CURRENT_HOUR == 5:
			IslandDirectionalLight.visible = true
			IslandDirectionalLight.light_color = SunriseColor
			
			var tween = get_tree().create_tween().set_parallel()
			tween.tween_property(IslandDirectionalLight, "light_energy", 1, HourTimer.wait_time).from(0)
			
			tween.tween_property(TheIslandProceduralSkyMaterial, "sky_top_color", Color(0.311, 0.463, 0.682), HourTimer.wait_time * 2.5)
			tween.tween_property(TheIslandProceduralSkyMaterial, "sky_horizon_color", Color(0.502, 0.641, 0.905), HourTimer.wait_time * 2.5)
			tween.tween_property(TheIslandProceduralSkyMaterial, "ground_bottom_color", Color(0.2, 0.169, 0.133), HourTimer.wait_time * 2.5)
			tween.tween_property(TheIslandProceduralSkyMaterial, "ground_horizon_color", Color(0.502, 0.641, 0.905), HourTimer.wait_time * 2.5)
			
			rotateSun(-32) 
			## -22 deg at finish
			## 10 deg at start
		
		if TimeManager.CURRENT_HOUR == 6:
			rotateSun(-15) 
			## -37 deg at finish
			## -22 deg at start
		
		if TimeManager.CURRENT_HOUR == 7:
			var tween = get_tree().create_tween()
			tween.tween_property(IslandDirectionalLight, "light_color", MiddayColor, HourTimer.wait_time * 2)
			rotateSun(-12) 
			## -49 deg at finish
			## -37 deg at start
			
		if TimeManager.CURRENT_HOUR == 8:
			rotateSun(-12)
			## -61 deg at finish
			## -49 deg at start
		
		if TimeManager.CURRENT_HOUR == 9:
			rotateSun(-9)
			## -70 deg at finish
			## -61 deg at start
		
		if TimeManager.CURRENT_HOUR == 10:
			rotateSun(-8)
			## -78 deg at finish
			## -70 deg at start
		
		if TimeManager.CURRENT_HOUR == 11:
			rotateSun(-7)
			## -85 deg at finish
			## -78 deg at start
	
		if TimeManager.CURRENT_HOUR == 12:
			rotateSun(-8)
			## -93 deg at finish
			## -85 deg at start
		
		if TimeManager.CURRENT_HOUR == 13:
			rotateSun(-9)
			## -102 deg at finish
			## -93 deg at start
		
		if TimeManager.CURRENT_HOUR == 14:
			rotateSun(-10)
			## -112 deg at finish
			## -102 deg at start
		
		if TimeManager.CURRENT_HOUR == 15:
			rotateSun(-12)
			## -124 deg at finish
			## -112 deg at start
		
		if TimeManager.CURRENT_HOUR == 16:
			var tween = get_tree().create_tween().set_parallel()
			tween.tween_property(IslandDirectionalLight, "light_color", SunsetColor, HourTimer.wait_time * 2)
			
			tween.tween_property(TheIslandProceduralSkyMaterial, "sky_top_color", Color(0.011, 0.011, 0.011), HourTimer.wait_time * 7)
			tween.tween_property(TheIslandProceduralSkyMaterial, "sky_horizon_color", Color(0.038, 0.038, 0.038), HourTimer.wait_time * 7)
			tween.tween_property(TheIslandProceduralSkyMaterial, "ground_bottom_color", Color(0, 0, 0), HourTimer.wait_time * 7)
			tween.tween_property(TheIslandProceduralSkyMaterial, "ground_horizon_color", Color(0, 0, 0), HourTimer.wait_time * 7)
			
			rotateSun(-15)
			## -139 deg at finish
			## -124 deg at start
		
		if TimeManager.CURRENT_HOUR == 17:
			rotateSun(-17)
			## -156 deg at finish
			## -139 deg at start
		
		if TimeManager.CURRENT_HOUR == 18:
			rotateSun(-12)
			## -168 deg at finish
			## -156 deg at start
		
		if TimeManager.CURRENT_HOUR == 19:
			rotateSun(-7)
			## -175 deg at finish
			## -168 deg at start
		
		if TimeManager.CURRENT_HOUR == 20:
			rotateSun(-7)
			## -182 deg at finish
			## -175 deg at start
		
		if TimeManager.CURRENT_HOUR == 21:
			var tween = get_tree().create_tween()
			tween.tween_property(IslandDirectionalLight, "light_energy", 0, HourTimer.wait_time)
			rotateSun(-7)
			## -189 deg at finish
			## -182 deg at start
		
		if TimeManager.CURRENT_HOUR == 22:
			IslandDirectionalLight.visible = false
			IslandDirectionalLight.rotation_degrees.x = 10.0
		
		if TimeManager.CURRENT_HOUR == 23:
			IslandDirectionalLight.visible = false
			IslandDirectionalLight.rotation_degrees.x = 10.0
		
		if TimeManager.CURRENT_HOUR == 0 or TimeManager.CURRENT_HOUR == 24:
			
			IslandDirectionalLight.visible = false
			IslandDirectionalLight.rotation_degrees.x = 10.0
			print("New day")
   

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
