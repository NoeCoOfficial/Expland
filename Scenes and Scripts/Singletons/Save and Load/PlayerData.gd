# ============================================================= #
# PlayerData.gd [AUTOLOAD]
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

var GAME_STATE = "NORMAL"
var Health := 100
var Hunger := 100
var Hydration := 100

func saveData(Island_Name : String) -> void:
	
	if IslandManager.Current_Game_Mode == "FREE":
		Utils.createIslandSaveFolder(Island_Name, "FREE")
		SAVE_PATH = "user://saveData/Free Mode/Islands/" + Island_Name + "/player.save"
		
	elif IslandManager.Current_Game_Mode == "STORY":
		Utils.createIslandSaveFolder(Island_Name, "STORY")
		SAVE_PATH = "user://saveData/Story Mode/Islands/" + Island_Name + "/player.save"
		
	elif IslandManager.Current_Game_Mode == "PARKOUR":
		Utils.createIslandSaveFolder(Island_Name, "PARKOUR")
		SAVE_PATH = "user://saveData/Parkour Mode/Runs/" + Island_Name + "/player.save"
	
	var Effect_data = PlayerManager.PLAYER
	
	var playerHead = get_node("/root/World/Player/Head")
	var playerCamera = get_node("/root/World/Player/Head/Camera3D")
	
	if PlayerManager.PLAYER:
		var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		var data = {
			"CURRENT_TIME" : TimeManager.CURRENT_TIME,
			"CURRENT_DAY" : TimeManager.CURRENT_DAY,
			"GAME_STATE" : GAME_STATE,
			"Health" : Health,
			"Hunger" : Hunger,
			"Position" : Utils.vector3_to_dict(PlayerManager.PLAYER.position),
			"HeadRotationY" : playerHead.rotation_degrees.y,
			"CameraRotationX" : playerCamera.rotation_degrees.x,
		}
		
		var jstr = JSON.stringify(data)
		file.store_line(jstr)
		file.close()
		print("[PlayerData] --Saved Player Data--")
	else:
		printerr("[PlayerData] Player node not found. SaveData failed.")

func loadData(Island_Name : String, withOutput : bool) -> void:
	
	if IslandManager.Current_Game_Mode == "FREE":
		Utils.createIslandSaveFolder(Island_Name, "FREE")
		SAVE_PATH = "user://saveData/Free Mode/Islands/" + Island_Name + "/player.save"
		
	elif IslandManager.Current_Game_Mode == "STORY":
		Utils.createIslandSaveFolder(Island_Name, "STORY")
		SAVE_PATH = "user://saveData/Story Mode/Islands/" + Island_Name + "/player.save"
		
	elif IslandManager.Current_Game_Mode == "STORY":
		Utils.createIslandSaveFolder(Island_Name, "STORY")
		SAVE_PATH = "user://saveData/Parkour Mode/Runs/" + Island_Name + "/player.save"
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		push_warning("[PlayerData] File doesn't exist (" + SAVE_PATH + ")")
		return
	
	if file and not file.eof_reached():
		var current_line = JSON.parse_string(file.get_line())
		
		if current_line:
			
			TimeManager.CURRENT_TIME = current_line["CURRENT_TIME"]
			TimeManager.CURRENT_DAY = current_line["CURRENT_DAY"]
			
			Health = current_line["Health"]
			Hunger = current_line["Hunger"]
			GAME_STATE = current_line["GAME_STATE"]
			
			var playerHead = get_node("/root/World/Player/Head")
			var playerCamera = get_node("/root/World/Player/Head/Camera3D")
			
			if PlayerManager.PLAYER:
				
				
				PlayerManager.PLAYER.position = Utils.dict_to_vector3(current_line["Position"]) ## Player Position
				
				playerHead.rotation_degrees.y = current_line["HeadRotationY"] ## Restore head rotation (only Y-axis)
				
				playerCamera.rotation_degrees.x = current_line["CameraRotationX"] ## Restore camera rotation (only X-axis)
				
				
				if withOutput:
					print_rich("[center][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Black.otf][font_size=30]-- PLAYER DATA HAS BEEN LOADED --[/font_size][/font][/center]")
				
					print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Current time: " + str(TimeManager.CURRENT_TIME) + "[/font][/font_size][/center]")
					print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Health: " + str(Health) + "[/font][/font_size][/center]")
					print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Hunger: " + str(Hunger) + "[/font][/font_size][/center]")
					print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Game State: " + GAME_STATE + "[/font][/font_size][/center]")
					print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Player Position: " + str(PlayerManager.PLAYER.position) + "[/font][/font_size][/center]")
					print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Head Y-Axis Rotation: " + str(playerHead.rotation_degrees.y) + "[/font][/font_size][/center]")
					print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Camera X-Axis Rotation: " + str(playerCamera.rotation_degrees.x) + "[/font][/font_size][/center]")
			else:
				printerr("[PlayerData] Player node not found. LoadData failed. 
				THIS MAY BE DUE TO YOUR PLAYER SCENE NOT BEING INSTANTIATED PROPERLY! 
				THE LOCAL DIRECTORY USED FOR RETRIEVING THE PLAYER NODE IS IN /root/World/Player. 
				THIS MEANS THAT YOUR SCENE NEEDS A ROOT NODE CALLED 'World' 
				AND THE PLAYER NEEDS TO BE A CHILD OF THAT ROOT NODE AND CALLED 'Player'.")
			
		file.close()
