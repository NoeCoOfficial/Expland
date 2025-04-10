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
var HOTBAR_SLOTS = []
var CHEST_SLOTS = []
var WORKBENCH_SLOTS = []
var WORKBENCH_OUTPUT_SLOT

var Droppable_Scene = preload("res://Scenes and Scripts/Scenes/Player/Inventory/InventoryDroppable.tscn")

func get_free_slot(Slots : Array):
	var free_slot = null
	for slot in Slots:
		if !slot.Populated:
			free_slot = slot
		return free_slot

func get_free_slot_using_stacks(Slots : Array, TARGET_ITEM_NAME : String):
	var free_slot = null
	var stack_slot = null
	
	for slot in Slots:
		# If 1 of the slots are free
		if !slot.Populated:
			free_slot = slot
			break
		# If there are no free slots. Then we check if we can stack.
		else:
			# If there is a slot with the same name as the target name
			if slot.Populating_Droppable.ITEM_TYPE["NAME"] == TARGET_ITEM_NAME:
				# We want this to happen if the stack count is SMALLER than the max.
				if slot.Populating_Droppable.Stack_Count < slot.Populating_Droppable.ITEM_TYPE["MAX_STACK"]:
					increment_droppable_stack(slot.Populating_Droppable, 1)
					stack_slot = true
					break
	
	if !stack_slot and free_slot == null:
		PlayerManager.MINIMAL_ALERT_PLAYER.spawn_minimal_alert(1.5, 0.3, 0.3, "Can't add item, pockets full!")
	
	return free_slot

func increment_droppable_stack(droppable_node : Node, increment : int):
	droppable_node.Stack_Count += increment

const ITEM_TYPES = {
	# Tools
	"AXE" : {
		"NAME" : "AXE",
		"DESCRIPTION" : "A tool used for cutting down trees.",
		"IMAGE_LOAD" : preload("uid://dq8jg5iy6tfyc"),
		"PICKUP_LOAD" : preload("uid://mmat24b7ftxq"),
		"HAND_ITEM_RES" : preload("uid://bpa3rcaw6dav2"),
		"MAX_STACK" : 1,
	},
	
	"PICKAXE" : {
		"NAME" : "PICKAXE",
		"DESCRIPTION" : "A tool for mining and breaking rocks.",
		"IMAGE_LOAD" : preload("uid://bxxnhb6vulkry"),
		"PICKUP_LOAD" : preload("uid://dplpg1yhca1b2"),
		"HAND_ITEM_RES" : preload("uid://blcr3veqy5vd7"),
		"MAX_STACK" : 1,
	},
	
	"SWORD" : {
		"NAME" : "SWORD",
		"DESCRIPTION" : "A bladed weapon for cutting and thrusting.",
		"IMAGE_LOAD" : preload("uid://dixs8s5v2su7q"),
		"PICKUP_LOAD" : preload("uid://bgqxctsm6c3w6"),
		"HAND_ITEM_RES" : preload("uid://bfl2kn5tjktpm"),
		"MAX_STACK" : 1,
	},
	
	# Flowers
	"BLANK FLOWER" : {
		"NAME" : "BLANK FLOWER",
		"DESCRIPTION" : "A blank flower.",
		"IMAGE_LOAD" : preload("uid://bu54o8nhdxuoh"),
		"PICKUP_LOAD" : preload("uid://c5kig8oo8rel3"),
		"MAX_STACK" : 10,
	},
	
	"BLUE FLOWER" : {
		"NAME" : "BLUE FLOWER",
		"DESCRIPTION" : "A blue flower.",
		"IMAGE_LOAD" : preload("uid://cavoja22gxr3s"),
		"PICKUP_LOAD" : preload("uid://cynuvm6lnyih2"),
		"MAX_STACK" : 10,
	},
	
	"RED FLOWER" : {
		"NAME" : "RED FLOWER",
		"DESCRIPTION" : "A red flower.",
		"IMAGE_LOAD" : preload("uid://m8ohdtvo6rfr"),
		"PICKUP_LOAD" : preload("uid://cje4v10u317y"),
		"MAX_STACK" : 10,
	},
	
	"PINK FLOWER" : {
		"NAME" : "PINK FLOWER",
		"DESCRIPTION" : "A pink flower.",
		"IMAGE_LOAD" : preload("uid://da0briqsyhmau"),
		"PICKUP_LOAD" : preload("uid://cdxp232v4i2lr"),
		"MAX_STACK" : 10,
	},
	
	"YELLOW FLOWER" : {
		"NAME" : "YELLOW FLOWER",
		"DESCRIPTION" : "A yellow flower.",
		"IMAGE_LOAD" : preload("uid://cqvxhihjcesqw"),
		"PICKUP_LOAD" : preload("uid://cyxxp35iw0434"),
		"MAX_STACK" : 10,
	},
	
	# Food
	"COCONUT" : {
		"NAME" : "COCONUT",
		"DESCRIPTION" : "A hard-shelled tropical fruit with white flesh and liquid inside.",
		"IMAGE_LOAD" : preload("uid://dmyiq1y00bivg"),
		"PICKUP_LOAD" : preload("uid://dm1ck0k7tfmel"),
		"HAND_ITEM_RES" : preload("uid://c4tfusakf730y"),
		"MAX_STACK" : 5,
	},
	
	# General
	"ROCK" : {
		"NAME" : "ROCK",
		"DESCRIPTION" : "A solid, natural mineral.",
		"IMAGE_LOAD" : preload("uid://b2eggg0vffmo4"),
		"PICKUP_LOAD" : preload("uid://0uyecq8yw6t"),
		"HAND_ITEM_RES" : preload("uid://bxmgf1s1s7u2l"),
		"MAX_STACK" : 7,
	},
	
	"STONE" : {
		"NAME" : "STONE",
		"DESCRIPTION" : "A solid, natural mineral.",
		"IMAGE_LOAD" : preload("uid://b1rh5wtv0cotk"),
		"PICKUP_LOAD" : preload("uid://cnca041yt8f3j"),
		"MAX_STACK" : 7,
	},
	
	"WOOD PLANK" : {
		"NAME" : "WOOD PLANK",
		"DESCRIPTION" : "A flat piece of timber.",
		"IMAGE_LOAD" : preload("uid://d2o42bjls3sl3"),
		"PICKUP_LOAD" : preload("uid://d1krxi2vcrc4m"),
		"MAX_STACK" : 5,
	},
	
	# Potions
	"EFFICIENCY POTION" : {
		"NAME" : "EFFICIENCY POTION",
		"DESCRIPTION" : "A potion that makes you more efficient, boosting output. This potion lasts for 60 seconds.",
		"IMAGE_LOAD" : preload("uid://don2d5onyupya"),
		"PICKUP_LOAD" : preload("uid://b8dojl031i6vl"),
		"HAND_ITEM_RES" : preload("uid://dqlyeqxv8q6i3"),
		"MAX_STACK" : 3,
	},
	
	"HASTE POTION" : {
		"NAME" : "HASTE POTION",
		"DESCRIPTION" : "A potion that makes you move faster. This potion's effect lasts for 30 seconds",
		"IMAGE_LOAD" : preload("uid://o3u6sxubmrbg"),
		"PICKUP_LOAD" : preload("uid://c3f07o736s1fc"),
		"HAND_ITEM_RES" : preload("uid://cyck7q8c0tn48"),
		"MAX_STACK" : 3,
	},
	
	"HEALTH POTION" : {
		"NAME" : "HEALTH POTION",
		"DESCRIPTION" : "A potion that regenerates health. This potion's effect lasts for 10 seconds",
		"IMAGE_LOAD" : preload("uid://1dbgnxe1pe1i"),
		"PICKUP_LOAD" : preload("uid://bkrrrciwr0l51"),
		"HAND_ITEM_RES" : preload("uid://bmejxgpqaj4x5"),
		"MAX_STACK" : 3,
	},
	
	"LUCK POTION" : {
		"NAME" : "LUCK POTION",
		"DESCRIPTION" : "A potion that boosts your luck. This potion's effect lasts for 120 seconds",
		"IMAGE_LOAD" : preload("uid://dkol2o53q7rck"),
		"PICKUP_LOAD" : preload("uid://dehytmc8mbpxu"),
		"HAND_ITEM_RES" : preload("uid://b3j61m3vj3wt1"),
		"MAX_STACK" : 3,
	},
	
	"NIGHT VISION POTION" : {
		"NAME" : "NIGHT VISION POTION",
		"DESCRIPTION" : "A potion that gives you night vision. This potion's effect lasts for 120 seconds",
		"IMAGE_LOAD" : preload("uid://d0q61bcnprn5o"),
		"PICKUP_LOAD" : preload("uid://gy86venr6fii"),
		"HAND_ITEM_RES" : preload("uid://cl1mh0eqikdhs"),
		"MAX_STACK" : 3,
	},
	
	"REGENERATING POTION" : {
		"NAME" : "REGENERATING POTION",
		"DESCRIPTION" : "A potion that regenerates your stats. This potion's effect lasts for 15 seconds",
		"IMAGE_LOAD" : preload("uid://mwa55qklwxe3"),
		"PICKUP_LOAD" : preload("uid://ic1v407ic2h3"),
		"HAND_ITEM_RES" : preload("uid://eg10f1ki8mlc"),
		"MAX_STACK" : 3,
	},
	
	"STAMINA POTION" : {
		"NAME" : "STAMINA POTION",
		"DESCRIPTION" : "A potion that boosts endurace. This potion's effect lasts for 60 seconds",
		"IMAGE_LOAD" : preload("uid://fj1pvfgfyamb"),
		"PICKUP_LOAD" : preload("uid://bk1v1bbw07mkj"),
		"HAND_ITEM_RES" : preload("uid://c8502f5nu4bha"),
		"MAX_STACK" : 3,
	},
	
	"STRENGTH POTION" : {
		"NAME" : "STRENGTH POTION",
		"DESCRIPTION" : "A potion that boosts your strength. This potion's effect lasts for 60 seconds",
		"IMAGE_LOAD" : preload("uid://bfiqh1ceg7rmt"),
		"PICKUP_LOAD" : preload("uid://d0ut80c3jd0lu"),
		"HAND_ITEM_RES" : preload("uid://ckwcfjfvp4mw5"),
		"MAX_STACK" : 3,
	},
}

const CONSUMABLE_ITEMS = [
	
	"HEALTH POTION", 
	"EFFICIENCY POTION", 
	"HASTE POTION",
	"LUCK POTION",
	"NIGHT VISION POTION",
	"REGENERATING POTION",
	"STAMINA POTION",
	"STRENGTH POTION",
	"HOLY GRAIL",
	
	"COCONUT",
	"COCONUT CAKE",
	"BERRY",
	"BLUEBERRY",
	"STRAWBERRY",
]

const FOOD_ITEMS = {
	"COCONUT": 20,
	"COCONUT CAKE": 40,
	"BERRY": 5,
	"BLUEBERRY": 7,
	"STRAWBERRY": 10,
}

const EFFECT_ITEMS = [
	"HEALTH POTION", 
	"EFFICIENCY POTION", 
	"HASTE POTION",
	"LUCK POTION",
	"NIGH TVISION POTION",
	"REGENERATING POTION",
	"STAMINA POTION",
	"STRENGTH POTION",
	"HOLY GRAIL",
]

var currently_selected_hotbar_slot : Node = null
var handitem_transition_tween

var pockets_ui_open : bool = false
var chest_ui_open : bool = false
var current_chest_node : Node = null
var workbench_ui_open : bool = false
var is_dragging : bool = false
var currently_dragging_node : Node

func setSelectedHotbarSlot(slotNode : Node, slotOutlineNode : Node, updateHandItem : bool = true, dropped_into_selected_hand_item : bool = false):
	var previously_selected_hotbar_slot = currently_selected_hotbar_slot
	#currently_selected_hotbar_slot = slotNode
	
	# Manage animations
	if handitem_transition_tween:
		handitem_transition_tween.kill()
	
	handitem_transition_tween = get_tree().create_tween()
	handitem_transition_tween.tween_property(
		PlayerManager.PLAYER.HandItemRig,
		"position",
		Vector3(0.477, -2.0, -0.274),
		0.1)
	
	if !dropped_into_selected_hand_item:
		# We check first if the previously selected hotbar slot
		# is the same as the one we want to go to
		# If yes, then deselect slot and hold nothing.
		if previously_selected_hotbar_slot == slotNode:
			for child in PlayerManager.PLAYER.InventoryLayer_HotbarSlotOutlines.get_children():
				if str(child.name).begins_with("Slot"):
					child.hide()
			
			currently_selected_hotbar_slot = null
			PlayerManager.PLAYER.HandItem.swap_items("")
		
		else:
			
			for child in PlayerManager.PLAYER.InventoryLayer_HotbarSlotOutlines.get_children():
				if child == slotOutlineNode:
					child.show()
				else:
					child.hide()
			
			currently_selected_hotbar_slot = slotNode
			if slotNode.Populating_Droppable:
				PlayerManager.PLAYER.HandItem.swap_items(slotNode.Populating_Droppable.ITEM_TYPE["NAME"])
			else:
				PlayerManager.PLAYER.HandItem.swap_items("")
		
	# If the droppable was dropped into a selected hotbar slot
	else:
		
		for child in PlayerManager.PLAYER.InventoryLayer_HotbarSlotOutlines.get_children():
			if child == slotOutlineNode:
				child.show()
			else:
				child.hide()
		
		currently_selected_hotbar_slot = slotNode
		if slotNode.Populating_Droppable:
			PlayerManager.PLAYER.HandItem.swap_items(slotNode.Populating_Droppable.ITEM_TYPE["NAME"])
		else:
			PlayerManager.PLAYER.HandItem.swap_items("")

func openPockets():
	# Show UI
	PlayerManager.PLAYER.InventoryLayer_Pockets.visible = true
	PlayerManager.PLAYER.InventoryLayer_GreyLayer.visible = true
	PlayerManager.PLAYER.InventoryLayer_Hotbar.mouse_filter = Control.MOUSE_FILTER_PASS
	pockets_ui_open = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func closePockets():
	# Hide UI
	PlayerManager.PLAYER.InventoryLayer_Pockets.visible = false
	PlayerManager.PLAYER.InventoryLayer_GreyLayer.visible = false
	PlayerManager.PLAYER.InventoryLayer_Hotbar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pockets_ui_open = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
