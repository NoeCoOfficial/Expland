I'm# ============================================================= #
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

@export var TickTimer : Timer

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
		match TimeManager.CURRENT_HOUR:
			1:
				# Go to hour 2
      pass
			2:
				# Go to hour 3
      pass
			3:
				# Go to hour 4
      pass
			4:
				# Go to hour 5
      pass
			5:
				# Go to hour 6
      pass
			6:
				# Go to hour 7
      pass
			7:
				# Go to hour 8
      pass
			8:
				# Go to hour 9
      pass
			9:
				# Go to hour 10
      pass
			10:
				# Go to hour 11
      pass
			11:
      # Go to hour 12
      pass	
			12:
				# Go to hour 13
      pass
			13:
				# Go to hour 14
      pass
			14:
				# Go to hour 15
      pass
			15:
				# Go to hour 16
      pass
			16:
				# Go to hour 17
      pass
			17:
				# Go to hour 18
      pass
			18:
				# Go to hour 19
      pass
			19:
				# Go to hour 20
      pass
			20:
				# Go to hour 21
      pass
			21:
				# Go to hour 22
      pass
			22:
	  		# Go to hour 23
      pass	
			23:
				# Go to hour 24
      pass

"""



func rotateSun(addX : float):
   var currentX = IslandDirectionalLight.rotation.x

   var newX = currentX + addX

   var tween = get_tree().create_tween()
   tween.tween_property(IslandDirectionalLight, "rotation:x", newX, TickTimer.wait_time).from(currentX)
   


12: Sun rotation at -90 (-7)
11: Sun rotation at -83 (-8)
10: Sun rotation at -75 (-9)
9: Sun rotation at -66 (-10)
8: Sun rotation at -56 (-12)
7: Sun rotation at -44 (-15)
6: Sun rotation at -39 (-17)
5: Sun rotation at -22 (-22)
4: Sun rotation at 0



"""
