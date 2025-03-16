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

var POCKET_SLOTS = []
var CHEST_SLOTS = []
var WORKSHOP_SLOTS = []
var WORKSHOP_OUTPUT_SLOT

func get_free_slot(Slots : Array):
	var free_slot = null
	for i in range(Slots.size()):
		if not Slots[i].is_populated():
			free_slot = Slots[i]
			return free_slot

const CONSUMABLE_ITEMS = [
	
	"HEALTHPOTION", 
	"EFFICIENCYPOTION", 
	"HASTEPOTION",
	"LUCKPOTION",
	"NIGHTVISIONPOTION",
	"REGENERATINGPOTION",
	"STAMINAPOTION",
	"STRENGTHPOTION",
	"HOLYGRAIL",
	
	"COCONUT",
	"COCONUTCAKE",
	"BERRY",
	"BLUEBERRY",
	"STRAWBERRY",
	
]

const FOOD_ITEMS = {
	"COCONUT": 20,
	"COCONUTCAKE": 40,
	"BERRY": 5,
	"BLUEBERRY": 7,
	"STRAWBERRY": 10,
}

const EFFECT_ITEMS = [
	"HEALTHPOTION", 
	"EFFICIENCYPOTION", 
	"HASTEPOTION",
	"LUCKPOTION",
	"NIGHTVISIONPOTION",
	"REGENERATINGPOTION",
	"STAMINAPOTION",
	"STRENGTHPOTION",
	"HOLYGRAIL",
]

var creatingFromInventory = false

var inventory_open = false
var in_chest_interface = false
var is_in_workbench_interface = false
var is_in_explorer_notes_interface = false

var is_dragging = false
var is_inside_boundary = false
var item_ref := ""
var item_ref_not_at_inventory :=  ""
var is_creating_pickup = false
var is_inside_checker = false

var chestNode

func create_pickup_object_at_pos(position : Vector3, ITEM_TYPE):
	creatingFromInventory = false
	
	item_ref_not_at_inventory = ITEM_TYPE
	
	var PICKUP_SCENE = load("res://Scenes and Scripts/Scenes/Player/Inventory/ItemPickupObject.tscn")
	var PICKUP = PICKUP_SCENE.instantiate()
	PlayerManager.WORLD.add_child(PICKUP)
	PICKUP.global_position = position

func create_pickup_object():
	creatingFromInventory = true
	
	if is_creating_pickup:
		return
	is_creating_pickup = true
	var PICKUP_SCENE = load("res://Scenes and Scripts/Scenes/Player/Inventory/ItemPickupObject.tscn")
	var PICKUP = PICKUP_SCENE.instantiate()
	PlayerManager.WORLD.add_child(PICKUP)
	
	is_creating_pickup = false
	

func spawn_inventory_dropable(atPos : Vector2, ITEM_TYPE, slotToPopulate, is_in_chest_slot : bool):
	if get_node("/root/World/Player/Head/Camera3D/InventoryLayer/InventoryMainLayer") != null:
		var ChestSlotsControl = get_node("/root/World/Player/Head/Camera3D/InventoryLayer/InventoryMainLayer/ChestMainLayer/ChestSlots")
		var InventoryLayer = get_node("/root/World/Player/Head/Camera3D/InventoryLayer/InventoryMainLayer")
		var NewDropable = load("res://Scenes and Scripts/Scenes/Player/Inventory/InventoryDropable.tscn")
		var DropableInstance = NewDropable.instantiate()
		DropableInstance.set_ITEM_TYPE(ITEM_TYPE)
		
		if is_in_chest_slot:
			ChestSlotsControl.add_child(DropableInstance)
			DropableInstance.position = atPos
		else:
			InventoryLayer.add_child(DropableInstance)
			DropableInstance.global_position = atPos
		
		DropableInstance.global_position = atPos
		DropableInstance.set_slot_inside(slotToPopulate)
		DropableInstance.set_is_in_chest_slot(is_in_chest_slot)
		slotToPopulate.set_populated(true)
		
		return DropableInstance

func spawn_inventory_dropable_from_load(atPos : Vector2, ITEM_TYPE, is_in_chest_slot : bool):
	if get_node("/root/World/Player/Head/Camera3D/InventoryLayer/InventoryMainLayer") != null:
		var ChestSlotsControl = get_node("/root/World/Player/Head/Camera3D/InventoryLayer/InventoryMainLayer/ChestMainLayer/ChestSlots")
		var InventoryLayer = get_node("/root/World/Player/Head/Camera3D/InventoryLayer/InventoryMainLayer")
		var NewDropable = load("res://Scenes and Scripts/Scenes/Player/Inventory/InventoryDropable.tscn")
		var DropableInstance = NewDropable.instantiate()
		
		DropableInstance.set_ITEM_TYPE(ITEM_TYPE)
		DropableInstance.set_is_in_chest_slot(is_in_chest_slot)
		
		if DropableInstance.get_is_in_chest_slot():
			
			ChestSlotsControl.add_child(DropableInstance)
			DropableInstance.position = atPos
			
		else:
			InventoryLayer.add_child(DropableInstance)
			DropableInstance.global_position = atPos

func spawn_workshop_dropable(atPos : Vector2, ITEM_TYPE, slotToPopulate):
	if get_node("/root/World/Player/Head/Camera3D/InventoryLayer/InventoryMainLayer") != null:
		var WorkbenchSlots = get_node("/root/World/Player/Head/Camera3D/InventoryLayer/InventoryMainLayer/WorkbenchMainLayer/WorkbenchSlots")
		var NewDropable = load("res://Scenes and Scripts/Scenes/Player/Inventory/InventoryDropable.tscn")
		var DropableInstance = NewDropable.instantiate()
		DropableInstance.set_ITEM_TYPE(ITEM_TYPE)
		
		WorkbenchSlots.add_child(DropableInstance)
		DropableInstance.position = atPos
		DropableInstance.top_level = true
		
		DropableInstance.set_slot_inside(slotToPopulate)
		DropableInstance.set_is_workshop_dropable(true)
		slotToPopulate.set_populated(true)
		
		CraftingManager.bindCraftingItem(ITEM_TYPE, int(String(slotToPopulate.name)[-1]) - 1)
		
		return DropableInstance

func spawn_workbench_output_dropable(ITEM_TYPE):
	if get_node("/root/World/Player/Head/Camera3D/InventoryLayer/InventoryMainLayer") != null:
		var WorkbenchSlots = get_node("/root/World/Player/Head/Camera3D/InventoryLayer/InventoryMainLayer/WorkbenchMainLayer/WorkbenchSlots")
		var NewDropable = load("res://Scenes and Scripts/Scenes/Player/Inventory/InventoryDropable.tscn")
		var DropableInstance = NewDropable.instantiate()
		DropableInstance.set_ITEM_TYPE(ITEM_TYPE)
		DropableInstance.set_is_workshop_output_dropable(true)
		DropableInstance.global_position = InventoryManager.WORKSHOP_OUTPUT_SLOT.global_position
		
		InventoryManager.WORKSHOP_OUTPUT_SLOT.set_is_touching_draggable(true)
		
		WorkbenchSlots.add_child(DropableInstance)
		
		print_rich("[color=purple]Output slot position: " + str(InventoryManager.WORKSHOP_OUTPUT_SLOT.global_position) + "[/color]")
		DropableInstance.top_level = true
		
		DropableInstance.set_slot_inside(InventoryManager.WORKSHOP_OUTPUT_SLOT)
		InventoryManager.WORKSHOP_OUTPUT_SLOT.set_populated(true)
		
		return DropableInstance

func get_hunger_restoration_value(item: String) -> int:
	if item in FOOD_ITEMS:
		return FOOD_ITEMS[item]
	return 0
