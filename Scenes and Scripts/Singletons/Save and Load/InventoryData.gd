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

var inventory_data = []

func collect_dropable_nodes(parent_node: Node):
	# Iterate through all the children of the parent node
	for child in parent_node.get_children():
		# Check if the node's name starts with "Dropable"
		if child.name.begins_with("Dropable"):
			# Retrieve position and ITEM_TYPE
			var position = child.global_position
			var item_type = child.get_ITEM_TYPE()
			
			# Store the data in a dictionary and add it to the array
			inventory_data.append({
				"position": position,
				"ITEM_TYPE": item_type
			})
	
	# Print the collected data after iterating
	print("Collected inventory data:")
	for entry in inventory_data:
		print(entry)

const INVENTORY_SAVE_PATH = "user://inventory.save"

func save_inventory(parent_node: Node) -> void:
	var inventory_data = []
	
	# Collect data from nodes with names starting with "Dropable"
	for child in parent_node.get_children():
		if child.name.begins_with("Dropable"):
			inventory_data.append({
				"position": Utils.vector3_to_dict(child.global_position),
				"ITEM_TYPE": child.get_ITEM_TYPE()
			})
	
	# Write to file as a single JSON string
	var file = FileAccess.open(INVENTORY_SAVE_PATH, FileAccess.WRITE)
	if file:
		var json_data = JSON.stringify(inventory_data)
		file.store_line(json_data)
		file.close()
		print("[InventoryData] --Saved Inventory Data--")
	else:
		printerr("[InventoryData] Failed to open inventory save file.")
