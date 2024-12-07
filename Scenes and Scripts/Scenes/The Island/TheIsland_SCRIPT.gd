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

@export var HourTimer : Timer

@export var IslandDirectionalLight : DirectionalLight3D
@export var IslandWorldEnvironment : WorldEnvironment


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

func _on_tick() -> void:
	if TimeManager.CURRENT_HOUR == 23:
		TimeManager.CURRENT_HOUR = 0
		
		# Go to hour 1
		
		SaveManager.saveAllData()
		print("New day")
	else:
		TimeManager.CURRENT_HOUR += 1
		SaveManager.saveAllData()
		print("Next hour: " + str(TimeManager.CURRENT_HOUR))
		
		
		
		if TimeManager.CURRENT_HOUR == 1:
			IslandDirectionalLight.visible = false
			IslandDirectionalLight.rotation_degrees.x = 0.0
			
		elif TimeManager.CURRENT_HOUR == 2:
			IslandDirectionalLight.visible = false
			IslandDirectionalLight.rotation_degrees.x = 0.0
		
		elif TimeManager.CURRENT_HOUR == 3:
			IslandDirectionalLight.visible = false
			IslandDirectionalLight.rotation_degrees.x = 0.0
		
		elif TimeManager.CURRENT_HOUR == 4:
			IslandDirectionalLight.visible = false
			IslandDirectionalLight.rotation_degrees.x = 0.0
		
		elif TimeManager.CURRENT_HOUR == 5:
			IslandDirectionalLight.visible = true
			IslandDirectionalLight.light_color = Color(0.793, 0.612, 0.18)
			var tween = get_tree().create_tween()
			tween.tween_property(IslandDirectionalLight, "light_energy", 1, HourTimer.wait_time).from(0)
			rotateSun(-22)
		
		elif TimeManager.CURRENT_HOUR == 6:
			rotateSun(-15)
		
		elif TimeManager.CURRENT_HOUR == 7:
			rotateSun(-12)
			var tween = get_tree().create_tween()
			tween.tween_property(IslandDirectionalLight, "light_color", Color(0.941, 0.987, 0.809), HourTimer.wait_time * 2)
		
		elif TimeManager.CURRENT_HOUR == 9:
			rotateSun(-9)
		
		elif TimeManager.CURRENT_HOUR == 10:
			rotateSun(-8)
		elif TimeManager.CURRENT_HOUR == 11:
			rotateSun(-7)
		elif TimeManager.CURRENT_HOUR == 12:
			rotateSun(-8)
		elif TimeManager.CURRENT_HOUR == 13:
			rotateSun(-9)
		elif TimeManager.CURRENT_HOUR == 14:
			rotateSun(-10)
		elif TimeManager.CURRENT_HOUR == 15:
			rotateSun(-12)
			var tween = get_tree().create_tween()
			tween.tween_property(IslandDirectionalLight, "light_color", Color(0.949, 0.58, 0.161), HourTimer.wait_time * 2)
		elif TimeManager.CURRENT_HOUR == 16:
			rotateSun(-15)
		elif TimeManager.CURRENT_HOUR == 17:
			rotateSun(-17)
		elif TimeManager.CURRENT_HOUR == 18:
			rotateSun(-12)
		elif TimeManager.CURRENT_HOUR == 19:
			rotateSun(-7)
		elif TimeManager.CURRENT_HOUR == 20:
			var tween = get_tree().create_tween()
			tween.tween_property(IslandDirectionalLight, "light_energy", 0, HourTimer.wait_time)
		elif TimeManager.CURRENT_HOUR == 21:
			IslandDirectionalLight.visible = false
			IslandDirectionalLight.rotation_degrees.x = 0.0
		elif TimeManager.CURRENT_HOUR == 22:
			IslandDirectionalLight.visible = false
			IslandDirectionalLight.rotation_degrees.x = 0.0
		elif TimeManager.CURRENT_HOUR == 23:
			IslandDirectionalLight.visible = false
			IslandDirectionalLight.rotation_degrees.x = 0.0
		elif TimeManager.CURRENT_HOUR == 0:
			IslandDirectionalLight.visible = false
			IslandDirectionalLight.rotation_degrees.x = 0.0
   

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
