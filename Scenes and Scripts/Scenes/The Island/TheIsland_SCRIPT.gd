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

var SKY_TRANS_TIME = 20.0

@export var RainParticles : CPUParticles3D
@export var Clouds : MeshInstance3D

@export var Player : CharacterBody3D

var transSunny_tween
var transRain_tween
var transStorm_tween
var transCloudy_tween


var MiddayColor = Color(0.941, 0.987, 0.809)
var SunriseColor = Color(0.793, 0.612, 0.18)
var SunsetColor = Color(0.98, 0.729, 0.312)

var NightCloudColor = Color(0, 0, 0)
var DayCloudColor = Color(0.367, 0.367, 0.367)


func _ready() -> void:
	randomize()
	initNodes()
	
	IslandManager.transitioning_from_menu = false
	
	PlayerData.loadData(IslandManager.Current_Island_Name, true)
	InventoryData.loadInventory(IslandManager.Current_Island_Name)
	
	PlayerManager.init()
	set_dof_blur(PlayerSettingsData.DOFBlur)
	
	"""
	if PlayerData.GAME_STATE == "SLEEPING":
		PlayerData.GAME_STATE = "NORMAL"
		set_hour(6)
	else:
		on_ready_time_check()
	"""
	
	Player.init_visually_equip(InventoryData.HAND_ITEM_TYPE)
	
	InventoryManager.chestNode = $Chest

func _on_ready() -> void:
	pass

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
	pass
