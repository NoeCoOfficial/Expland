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

func _process(_delta: float) -> void:
	if IslandManager.transitioning_from_menu:
		$Continue_Btn.disabled = true
		$Info_Btn.disabled = true
		$Edit_Btn.disabled = true
		$Delete_Btn.disabled = true

func initializeProperties(island_name: String, gameplay_image_path: String) -> void:
	# Set the island name text
	$Island_Name_TextEdit.text = island_name
	current_name_submitted = island_name

	if gameplay_image_path != "":
		# Load the image from the provided path
		var image = Image.new()
		var error = image.load(gameplay_image_path)
		
		if error == OK:
			# Create a texture from the image
			var texture_instance = ImageTexture.create_from_image(image)
			$PanelContainer/TextureRect.texture = texture_instance
		else:
			# Handle the error by loading the fallback image
			print("Failed to load image: %s" % gameplay_image_path)
			load_fallback_texture()
	else:
		# No path provided, use fallback image
		load_fallback_texture()

func load_fallback_texture() -> void:
	# Load and set a fallback texture
	$PanelContainer/TextureRect.texture = preload("res://Textures/Images/DefaultLoadImage.png")


func _on_info_btn_pressed() -> void:
	var minimal_popup_node = get_node("/root/MainMenu/Camera3D/MainLayer/FreeModeIslandPopup/MinimalAlert")
	
	if minimal_popup_node != null:
		minimal_popup_node.spawn_minimal_alert(2, 0.5, 0.5, "Viewing Island information isn't available yet!")

func _on_edit_btn_pressed() -> void:
	var minimal_popup_node = get_node("/root/MainMenu/Camera3D/MainLayer/FreeModeIslandPopup/MinimalAlert")
	
	if minimal_popup_node != null:
		minimal_popup_node.spawn_minimal_alert(2, 0.5, 0.5, "Editing Island information isn't available yet!")

func _on_delete_btn_pressed() -> void:
	pass


func _on_island_name_text_edit_focus_entered() -> void:
	AudioManager.canOperate_textField = false

func _on_island_name_text_edit_focus_exited() -> void:
	AudioManager.canOperate_textField = true
