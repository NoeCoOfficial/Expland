# ============================================================= #
# InventoryManager.gd [AUTOLOAD]
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

var creatingFromInventory = false

var inventory_open = false
var in_chest_interface = false

var is_dragging = false
var is_inside_boundary = false
var item_ref: String = ""
var item_ref_not_at_inventory: String =  ""
var is_creating_pickup = false
var is_inside_checker = false

var is_hovering_over_hand_dropable = false

var chestNode

func create_pickup_object_at_pos(position : Vector3, ITEM_TYPE):
	creatingFromInventory = false
	
	item_ref_not_at_inventory = ITEM_TYPE
	
	var WORLD = get_node("/root/World")
	var PICKUP_SCENE = load("res://Scenes and Scripts/Scenes/Player/Inventory/ItemPickupObject.tscn")
	var PICKUP = PICKUP_SCENE.instantiate()
	WORLD.add_child(PICKUP)
	PICKUP.global_position = position

func create_pickup_object():
	creatingFromInventory = true
	
	if is_creating_pickup:
		return
	is_creating_pickup = true
	var WORLD = get_node("/root/World")
	var INVENTORY_LAYER = get_node("/root/World/Player/Head/Camera3D/InventoryLayer")
	var PICKUP_SCENE = load("res://Scenes and Scripts/Scenes/Player/Inventory/ItemPickupObject.tscn")
	var PICKUP = PICKUP_SCENE.instantiate()
	WORLD.add_child(PICKUP)
	
	is_creating_pickup = false
	
	InventoryData.saveInventory(IslandManager.Current_Island_Name, INVENTORY_LAYER)

func spawn_inventory_dropable(atPos : Vector2, ITEM_TYPE, slotToPopulate):
	if get_node("/root/World/Player/Head/Camera3D/InventoryLayer") != null:
		var InventoryLayer = get_node("/root/World/Player/Head/Camera3D/InventoryLayer")
		var NewDropable = load("res://Scenes and Scripts/Scenes/Player/Inventory/InventoryDropable.tscn")
		var DropableInstance = NewDropable.instantiate()
		DropableInstance.set_ITEM_TYPE(ITEM_TYPE)
		
		InventoryLayer.add_child(DropableInstance)
		DropableInstance.position = atPos
		DropableInstance.set_slot_inside(slotToPopulate)
		slotToPopulate.set_populated(true)
		
		return DropableInstance

func spawn_inventory_dropable_from_load(atPos : Vector2, ITEM_TYPE):
	if get_node("/root/World/Player/Head/Camera3D/InventoryLayer") != null:
		var InventoryLayer = get_node("/root/World/Player/Head/Camera3D/InventoryLayer")
		var NewDropable = load("res://Scenes and Scripts/Scenes/Player/Inventory/InventoryDropable.tscn")
		var DropableInstance = NewDropable.instantiate()
		DropableInstance.set_ITEM_TYPE(ITEM_TYPE)
		
		InventoryLayer.add_child(DropableInstance)
		DropableInstance.position = atPos

func set_hand_item(dropable_to_delete, ITEM_TYPE : String):
	var PLAYER = get_node("/root/World/Player")
	if InventoryData.HAND_ITEM_TYPE != "":
		spawn_inventory_dropable(dropable_to_delete.position, InventoryData.HAND_ITEM_TYPE, dropable_to_delete.get_slot_inside())
	dropable_to_delete.queue_free()
	PLAYER.set_hand_item_type(ITEM_TYPE)
