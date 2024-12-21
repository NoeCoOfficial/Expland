# ============================================================= #
# IslandSaveElement_SCRIPT.gd
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

@icon("res://Textures/Icons/Script Icons/32x32/disk_save.png")
extends Control

var current_name_submitted : String
var game_mode

func _ready() -> void:
	name = "IslandSaveElement"

func initializeProperties(Island_Name : String, gameplay_image_path : String) -> void:
	$Island_Name_TextEdit.text = Island_Name
	current_name_submitted = Island_Name
	
	if gameplay_image_path != "":
		var texture = ResourceLoader.load(gameplay_image_path)
		if texture:
			$PanelContainer/TextureRect.texture = texture
		else:
			print("Failed to load image: %s" % gameplay_image_path)

func _on_continue_btn_pressed() -> void:
	var main_menu = get_node("/root/MainMenu")
	var dir = DirAccess.open("res://saveData/Free Mode/Islands")
	var text_edit = $Island_Name_TextEdit
	var text = text_edit.text
	var invalid_chars = ["/", "\\", "|", "*", "<", ">", "\"", "?", ":", "+", "\t", "\n", "\r"]
	var sanitized_name = ""
	var has_valid_char = false
	
	for character in text:
		if character not in invalid_chars:
			sanitized_name += character
			if character != " ":
				has_valid_char = true
	
	# Remove trailing spaces
	while sanitized_name.ends_with(" "):
		sanitized_name = sanitized_name.substr(0, sanitized_name.length() - 1)
	
	if sanitized_name.length() > 100:
		sanitized_name = sanitized_name.substr(0, 100)
	
	# Remove trailing spaces again after length check
	while sanitized_name.ends_with(" "):
		sanitized_name = sanitized_name.substr(0, sanitized_name.length() - 1)
	
	if dir:
		dir.list_dir_begin()
		var folder_name = dir.get_next()
		while folder_name != "":
			if dir.current_is_dir() and folder_name != "." and folder_name != "..":
				if folder_name == sanitized_name and folder_name != current_name_submitted:
					print("Island name already exists: ", sanitized_name)
					var minimal_alert = get_node("/root/MainMenu/Camera3D/MainLayer/FreeModeIslandPopup/MinimalAlert")
					minimal_alert.spawn_minimal_alert(4, 0.5, 0.5, "Island name already exists. Please choose a different name.")
					return
			folder_name = dir.get_next()
		dir.list_dir_end()
	
	text_edit.text = sanitized_name
	dir.rename(current_name_submitted, text_edit.text)
	current_name_submitted = text_edit.text
	
	text_edit.editable = false
	text_edit.focus_mode = 0
	$Delete_Btn.focus_mode = 0
	
	$Continue_Btn.disabled = true
	$Delete_Btn.disabled = true

	main_menu.goToIsland(current_name_submitted, "FREE")

func _on_island_name_text_edit_text_submitted(new_text: String) -> void:
	pass # Replace with function body.

func _on_info_btn_pressed() -> void:
	pass
	# TODO
	# Get main menu node
	# Create popup node in main menu
	# Get popup node
	# Display popup with the info

func _on_edit_btn_pressed() -> void:
	var minimal_popup_node = get_node("/root/MainMenu/Camera3D/MainLayer/FreeModeIslandPopup/MinimalAlert")
	
	if minimal_popup_node != null:
		minimal_popup_node.spawn_minimal_alert(3, 0.5, 0.5, "This feature isn't available yet!")

func _on_delete_btn_pressed() -> void:
	pass
	# TODO
	# Create new binary choice popup scene
	# Instace it into the main menu
	# Get main menu node
	# Open the popup
