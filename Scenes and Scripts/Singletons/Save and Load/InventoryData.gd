# ============================================================= #
# InventoryData.gd [AUTOLOAD]
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

var INVENTORY_SAVE_PATH = ""

var inventory_data = []
var CURRENT_ITEM_IN_HAND : String = ""

func saveInventory(Island_Name : String, parent_node: Node, chest_parent_node: Node) -> void:
	
	if IslandManager.Current_Game_Mode == "FREE":
		Utils.createIslandSaveFolder(Island_Name, "FREE")
		INVENTORY_SAVE_PATH = "user://saveData/Free Mode/Islands/" + Island_Name + "/inventory.save"
		
	elif IslandManager.Current_Game_Mode == "STORY":
		Utils.createIslandSaveFolder(Island_Name, "STORY")
		INVENTORY_SAVE_PATH = "user://saveData/Story Mode/Islands/" + Island_Name + "/inventory.save"
		
	# Clear the inventory_data before saving
	inventory_data.clear()
	print("[InventoryData] Clearing old inventory data.")
	
	# Collect data from nodes with names starting with "Dropable" in parent_node
	for child in parent_node.get_children():
		if child.name.begins_with("Dropable"):
			var drop_data = {
				"ITEM_TYPE": child.get_ITEM_TYPE(),
				"is_in_chest_slot": child.get_is_in_chest_slot(),
			}
			
			if child.get_is_in_chest_slot():
				drop_data["position"] = Utils.vector2_to_dict(child.get_slot_inside().position)
			else:
				drop_data["position"] = Utils.vector2_to_dict(child.get_slot_inside().global_position)
			
			inventory_data.append(drop_data)
	
	# Collect data from nodes with names starting with "Dropable" in chest_parent_node
	for child in chest_parent_node.get_children():
		if child.name.begins_with("Dropable"):
			var drop_data = {
				"ITEM_TYPE": child.get_ITEM_TYPE(),
				"is_in_chest_slot": child.get_is_in_chest_slot(),
			}
			
			if child.get_is_in_chest_slot():
				drop_data["position"] = Utils.vector2_to_dict(child.get_slot_inside().position)
			else:
				drop_data["position"] = Utils.vector2_to_dict(child.get_slot_inside().global_position)
			
			inventory_data.append(drop_data)
	
	# Debugging: Ensure inventory_data contains all collected items
	print("[InventoryData] Final inventory_data array: ", inventory_data)
	
	var save_data = {
		"inventory": inventory_data,
		
		"current_item_in_hand": CURRENT_ITEM_IN_HAND,
		
		"selected_hotbar_slot_name" : HotbarManager.CURRENTLY_SELECTED_SLOT_NAME
		
	}

	# Write fresh data to the file
	var file = FileAccess.open(INVENTORY_SAVE_PATH, FileAccess.WRITE)
	if file:
		var json_data = JSON.stringify(save_data)
		file.store_line(json_data)
		file.close()
		print("[InventoryData] --Saved Inventory Data--")
	else:
		printerr("[InventoryData] Failed to open inventory save file.")

func loadInventory(Island_Name : String) -> void:
	Utils.createIslandSaveFolder(Island_Name, "FREE")
	INVENTORY_SAVE_PATH = "user://saveData/Free Mode/Islands/" + Island_Name + "/inventory.save"
	
	var file = FileAccess.open(INVENTORY_SAVE_PATH, FileAccess.READ)
	if not file:
		print("[InventoryData] File doesn't exist (" + INVENTORY_SAVE_PATH + ")")
		return
	
	if file and not file.eof_reached():
		var current_line = JSON.parse_string(file.get_line())
		if not current_line or current_line == {}:
			print("[InventoryData] No inventory data to load.")
			return
		
		# Update the in-memory inventory data
		inventory_data = current_line["inventory"]
		CURRENT_ITEM_IN_HAND = current_line["current_item_in_hand"]
		HotbarManager.CURRENTLY_SELECTED_SLOT_NAME = current_line["selected_hotbar_slot_name"]
		
		# Spawn inventory items based on loaded data
		for item in inventory_data:
			var position = Utils.dict_to_vector2(item["position"])
			var item_type = item["ITEM_TYPE"]
			var is_in_chest_slot = item["is_in_chest_slot"]
			
			InventoryManager.spawn_inventory_dropable_from_load(position, item_type, is_in_chest_slot)
		
		# Debugging output
		print_rich("[center][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Black.otf][font_size=30]-- INVENTORY DATA LOADED --[/font_size][/font][/center]")
		for item in inventory_data:
			print_rich(
				"[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Position: " 
				+ str(Utils.dict_to_vector2(item["position"])) 
				+ ", ITEM_TYPE: " 
				+ item["ITEM_TYPE"] 
				+ ", Is in chest slot: " 
				+ str(item["is_in_chest_slot"])
				+ "[/font][/font_size][/center]"
			)
	else:
		push_warning("[InventoryData] Failed to parse JSON data from file.")
	
	file.close()

func clearInventory(parent_node : Node):
	inventory_data.clear()
	
	for child in parent_node.get_children():
		if child.name.begins_with("Dropable"):
			child.queue_free()
		elif child.name.begins_with("Slot"):
			child.set_populated(false)
