# ============================================================= #
# CraftingManager.gd [AUTOLOAD]
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

var CURRENT_CRAFTING_ITEMS = [
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	""
]

const RECIPES = [
	
	["PICKAXE", [
		
			"",      "STONE", "STONE", 
			
		"",      "WOODPLANK",   "STONE", 
		
		"WOODPLANK", "", ""]
		
		],
		
]

func _ready() -> void:
	SignalBus.connect("pressed_craft", Craft)

func bindCraftingItem(ITEM_TYPE : String, atIndex : int):
	CURRENT_CRAFTING_ITEMS[atIndex] = ITEM_TYPE
	print_rich("[color=green]Binding crafting item.[/color]")
	print_stack()


func unbindCraftingItem(atIndex : int):
	CURRENT_CRAFTING_ITEMS[atIndex] = ""
	print_rich("[color=red]Unbinding crafting item.[/color]")
	print_stack()

func Craft():
	var crafted_item = runCraftingChecks()
	if crafted_item != "":
		print("Crafted item: ", crafted_item)
		SignalBus.spawn_crafted_item.emit(crafted_item)
	else:
		print("No matching recipe found.")

func runCraftingChecks() -> String:
	for recipe in RECIPES:
		var sorted_recipe_items = recipe[1].duplicate()
		sorted_recipe_items.sort()
		var sorted_current_items = CURRENT_CRAFTING_ITEMS.duplicate()
		sorted_current_items.sort()
		if sorted_recipe_items == sorted_current_items:
			return recipe[0]
	return ""

func resetCurrentCraftingItems():
	CURRENT_CRAFTING_ITEMS = [
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	""
	]
