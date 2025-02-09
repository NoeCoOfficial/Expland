# ============================================================= #
# IslandData.gd [AUTOLOAD]
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
extends Node

var SAVE_PATH = ""

func saveData(Island_Name : String) -> void:
	
	if IslandManager.Current_Game_Mode == "FREE":
		Utils.createIslandSaveFolder(Island_Name, "FREE")
		SAVE_PATH = "user://saveData/Free Mode/Islands/" + Island_Name + "/island.save"
		
	elif IslandManager.Current_Game_Mode == "STORY":
		Utils.createIslandSaveFolder(Island_Name, "STORY")
		SAVE_PATH = "user://saveData/Story Mode/Islands/" + Island_Name + "/island.save"
		
	elif IslandManager.Current_Game_Mode == "STORY":
		Utils.createIslandSaveFolder(Island_Name, "STORY")
		SAVE_PATH = "user://saveData/Parkour Mode/Runs/" + Island_Name + "/island.save"
	
	
	
		var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		var data = {
			"Collected_Explorer_Notes" : ExplorerNotesManager.COLLECTED_NOTES
		}
		
		var jstr = JSON.stringify(data)
		file.store_line(jstr)
		file.close()
		print("[IslandData] --Saved Island Data--")

func loadData(Island_Name : String, withOutput : bool) -> void:
	
	if IslandManager.Current_Game_Mode == "FREE":
		Utils.createIslandSaveFolder(Island_Name, "FREE")
		SAVE_PATH = "user://saveData/Free Mode/Islands/" + Island_Name + "/island.save"
		
	elif IslandManager.Current_Game_Mode == "STORY":
		Utils.createIslandSaveFolder(Island_Name, "STORY")
		SAVE_PATH = "user://saveData/Story Mode/Islands/" + Island_Name + "/island.save"
		
	elif IslandManager.Current_Game_Mode == "STORY":
		Utils.createIslandSaveFolder(Island_Name, "STORY")
		SAVE_PATH = "user://saveData/Parkour Mode/Runs/" + Island_Name + "/island.save"
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		push_warning("[IslandData] File doesn't exist (" + SAVE_PATH + ")")
		return
	
	if file and not file.eof_reached():
		var current_line = JSON.parse_string(file.get_line())
		
		if current_line:
			pass
				
			if withOutput:
				print_rich("[center][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Black.otf][font_size=30]-- ISLAND DATA HAS BEEN LOADED --[/font_size][/font][/center]")
			
		file.close()
