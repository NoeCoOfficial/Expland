# ============================================================= #
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
