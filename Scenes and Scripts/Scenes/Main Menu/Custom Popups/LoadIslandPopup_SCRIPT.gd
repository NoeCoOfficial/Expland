# ============================================================= #
# LoadIslandPopup_SCRIPT.gd
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

extends Control

func _ready() -> void:
	visible = false

func loadIslands() -> void:
	var dir = DirAccess.open("user://saveData/Free Mode/Islands/")
	if dir:
		var folders = []
		dir.list_dir_begin()
		var folder_name = dir.get_next()
		while folder_name != "":
			if dir.current_is_dir() and folder_name != "." and folder_name != "..":
				folders.append({"name": folder_name})
			folder_name = dir.get_next()
		dir.list_dir_end()
		
		print("Number of island folders found: ", folders.size())
		IslandManager.FreeMode_Island_Count = folders.size()
		
		var ordered_folders = []
		for island_name in IslandAccessOrder.island_access_order:
			for folder in folders:
				if folder["name"] == island_name:
					ordered_folders.append(folder)
					break
		
		# Check if ordered_folders is empty and set the label visibility
		if ordered_folders.size() == 0:
			$NoSavedIslandsNotice.visible = true
		else:
			$NoSavedIslandsNotice.visible = false
		
		# Populate the UI with the folders
		for folder in ordered_folders:
			print_rich("[color=red]Detected folder: %s[/color]" % folder["name"])
			
			var island_save_element = load("res://Scenes and Scripts/Scenes/Main Menu/IslandSaveElement/IslandSaveElement.tscn").instantiate()
			$ScrollContainer/VBoxContainer.add_child(island_save_element)
			island_save_element.name = "IslandSaveElement"
			
			var image_path = "user://saveData/Free Mode/Islands/%s/island.png" % folder["name"]
			if not FileAccess.file_exists(image_path):
				image_path = ""
			island_save_element.initializeProperties(folder["name"], image_path)

func showPopup():
	visible = true

func loadAndShow() -> void:
	visible = true
	var dir = DirAccess.open("user://saveData/Free Mode/Islands/")
	if dir:
		var folders = []
		dir.list_dir_begin()
		var folder_name = dir.get_next()
		while folder_name != "":
			if dir.current_is_dir() and folder_name != "." and folder_name != "..":
				folders.append({"name": folder_name})
			folder_name = dir.get_next()
		dir.list_dir_end()
		
		var ordered_folders = []
		for island_name in IslandAccessOrder.island_access_order:
			for folder in folders:
				if folder["name"] == island_name:
					ordered_folders.append(folder)
					break
		
		print("Number of island folders found: ", folders.size())
		IslandManager.FreeMode_Island_Count = folders.size()
		
		# Check if ordered_folders is empty and set the label visibility
		if ordered_folders.size() == 0:
			$NoSavedIslandsNotice.visible = true
		else:
			$NoSavedIslandsNotice.visible = false
		
		# Populate the UI with the folders
		for folder in ordered_folders:
			print_rich("[color=red]Detected folder: %s[/color]" % folder["name"])
			
			var island_save_element = load("res://Scenes and Scripts/Scenes/Main Menu/IslandSaveElement/IslandSaveElement.tscn").instantiate()
			$ScrollContainer/VBoxContainer.add_child(island_save_element)
			island_save_element.name = "IslandSaveElement"
			
			var image_path = "user://saveData/Free Mode/Islands/%s/island.png" % folder["name"]
			if not FileAccess.file_exists(image_path):
				image_path = ""
			island_save_element.initializeProperties(folder["name"], image_path)

func clearOldElements() -> void:
	var container = $ScrollContainer/VBoxContainer
	for child in container.get_children():
		if child.name.begins_with("IslandSaveElement"):
			container.remove_child(child)
			child.queue_free()
