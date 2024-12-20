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

# Island Save file element path: "res://Scenes and Scripts/Scenes/Main Menu/IslandSaveElement/IslandSaveElement.tscn"
# Space divider path: "res://Scenes and Scripts/Scenes/Main Menu/SpaceDivider_Label.tscn"

func _ready() -> void:
	visible = false

func loadAndShow() -> void:
	var dir = DirAccess.open("res://saveData/Free Mode/Islands/")
	if dir == OK:
		dir.list_dir_begin()
		var first_element = true
		var folder_name = dir.get_next()
		while folder_name != "":
			if dir.current_is_dir() and folder_name != "." and folder_name != "..":
				if not first_element:
					var space_divider = load("res://path/to/SpaceDivider.tscn").instance()
					add_child(space_divider)
				first_element = false
				var island_save_element = load("res://path/to/IslandSaveElement.tscn").instance()
				add_child(island_save_element)
				island_save_element.initializeProperties(folder_name)
			folder_name = dir.get_next()
		dir.list_dir_end()