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

var Dropable_Scene = preload("res://Scenes and Scripts/Scenes/Player/Inventory/InventoryDroppable.tscn")

func get_free_slot(Slots : Array):
	var free_slot = null
	for i in range(Slots.size()):
		if !Slots[i].Populated:
			free_slot = Slots[i]
			return free_slot


const ITEM_TYPES = {
	"AXE" : {
		"NAME" : "AXE",
		"DESCRIPTION" : "A tool used for cutting down trees.",
		"IMAGE_LOAD" : preload("uid://dq8jg5iy6tfyc"),
		"PICKUP_LOAD" : preload("uid://mmat24b7ftxq"),
		"MAX_STACK" : 1,
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

var pockets_ui_open : bool = false
var is_dragging : bool = false
var currently_dragging_node : Node

func openPockets():
	# Show UI
	PlayerManager.PLAYER.InventoryLayer_CanvasLayer.visible = true
	PlayerManager.PLAYER.InventoryLayer_Pockets.visible = true
	pockets_ui_open = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func closePockets():
	PlayerManager.PLAYER.InventoryLayer_CanvasLayer.visible = false
	PlayerManager.PLAYER.InventoryLayer_Pockets.visible = false
	pockets_ui_open = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
