# ============================================================= #
# BuildingManager.gd [AUTOLOAD]
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

extends Node

var BuildingVignette : ShaderMaterial = preload("res://Resources/Shader Materials/BuildingVignette.tres")

var BA_PhysicalObject : PackedScene = preload("res://Scenes and Scripts/Scenes/Building System/Building Assets/Physical/BA_PhysicalObject.tscn")
var BA_StaticObject : PackedScene = preload("res://Scenes and Scripts/Scenes/Building System/Building Assets/Static/BA_StaticObject.tscn")

var CanBuildMaterial : StandardMaterial3D = preload("res://Resources/Materials/BuildingPlaceColorOverride.tres")
var CantBuildMaterial : StandardMaterial3D = preload("res://Resources/Materials/BuildingCantPlaceColorOverride.tres") 

var vignette_tween : Tween

var is_in_building_interface : bool = false
var is_in_building_edit_interface : bool = false
var can_build : bool = true

func build():
	pass

func init_building_system():
	# First, check if we are not in the building interface
	if !is_in_building_interface:
	# Check if what we are holding actually exists
		if HandManager.CURRENTLY_HOLDING_ITEM != "":
			is_in_building_interface = true
			PlayerManager.PLAYER.BuildingUILayer.visible = true
			
			var tween = get_tree().create_tween()
			tween.tween_property(BuildingVignette, "shader_parameter/alpha", 0.4, 0.2)
			
			var building_asset_res = InventoryManager.ITEM_TYPES[HandManager.CURRENTLY_HOLDING_ITEM]["BUILDING_ASSET_RES"]
			var model_instance = building_asset_res.Model_Scene.instantiate()
			
			PlayerManager.PLAYER.BuildingItemParent.add_child(model_instance)
			
			model_instance.position = building_asset_res.Spawn_Position
			model_instance.rotation_degrees = building_asset_res.Spawn_Rotation
			model_instance.scale = building_asset_res.Spawn_Scale
			
			
			for child in model_instance.get_children():
				if child is MeshInstance3D:
					if can_build:
						child.material_override = CanBuildMaterial
					else:
						child.material_override = CantBuildMaterial
			
			print("spawned building system")

func despawn_building_system():
	if is_in_building_interface:
		is_in_building_interface = false
		PlayerManager.PLAYER.BuildingUILayer.visible = false
		if is_in_building_edit_interface:
			despawn_edit()
		
		var tween = get_tree().create_tween()
		tween.tween_property(BuildingVignette, "shader_parameter/alpha", 0.0, 0.2)
		
		for child in PlayerManager.PLAYER.BuildingItemParent.get_children():
			if child is Node3D:
				child.queue_free()
		
		print("despawned building system")


func init_edit():
	is_in_building_edit_interface = true
	PlayerManager.PLAYER.BuildingUIEditLayer.visible = true
	PlayerManager.PLAYER.BuildingEditKeyMessage.text = "Exit Edit"
	print("in edit interface")

func despawn_edit():
	is_in_building_edit_interface = false
	PlayerManager.PLAYER.BuildingUIEditLayer.visible = false
	PlayerManager.PLAYER.BuildingEditKeyMessage.text = "Edit"
	print("exited edit interface")

func toggle_can_build(toggle : bool = true, update_mesh : bool = true):
	can_build = toggle
	
	if is_in_building_interface:
		if update_mesh:
			for child in PlayerManager.PLAYER.BuildingItemParent.get_child(0).get_children():
				if child is MeshInstance3D:
					if toggle:
						child.material_override = CanBuildMaterial
					else:
						child.material_override = CantBuildMaterial
