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

const SAVE_PATH = "res://player.save"


var GAME_STATE = "NORMAL"
var Health := 100


func saveData() -> void:
	var player = get_node("/root/World/Player")
	var playerHead = get_node("/root/World/Player/Head")
	var playerCamera = get_node("/root/World/Player/Head/Camera3D")
	
	if player:
		var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		var data = {
			"CURRENT_HOUR" : TimeManager.CURRENT_HOUR,
			"GAME_STATE" : GAME_STATE,
			"Health" : Health,
			"Position" : Utils.vector3_to_dict(player.position),
			"HeadRotationY" : playerHead.rotation_degrees.y,  # Save only Y rotation for the head
			"CameraRotationX" : playerCamera.rotation_degrees.x  # Save only X rotation for the camera
		}
		var jstr = JSON.stringify(data)
		file.store_line(jstr)
		file.close()
		print("[PlayerData] --Saved Player Data--")
	else:
		printerr("[PlayerData] Player node not found. SaveData failed.")

func loadData() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		push_warning("[PlayerData] File doesn't exist (" + SAVE_PATH + ")")
		return
	
	if file and not file.eof_reached():
		var current_line = JSON.parse_string(file.get_line())
		if current_line:
			TimeManager.CURRENT_HOUR = current_line["CURRENT_HOUR"]
			
			Health = current_line["Health"]
			GAME_STATE = current_line["GAME_STATE"]
			
			var player = get_node("/root/World/Player")
			var playerHead = get_node("/root/World/Player/Head")
			var playerCamera = get_node("/root/World/Player/Head/Camera3D")
			
			if player:
				
				
				player.position = Utils.dict_to_vector3(current_line["Position"]) ## Player Position
				
				playerHead.rotation_degrees.y = current_line["HeadRotationY"] ## Restore head rotation (only Y-axis)
				
				playerCamera.rotation_degrees.x = current_line["CameraRotationX"] ## Restore camera rotation (only X-axis)
				
				
				
				print_rich("[center][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Black.otf][font_size=30]-- PLAYER DATA HAS BEEN LOADED --[/font_size][/font][/center]")
				
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Current hour: " + str(TimeManager.CURRENT_HOUR) + "[/font][/font_size][/center]")
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Health: " + str(Health) + "[/font][/font_size][/center]")
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Game State: " + GAME_STATE + "[/font][/font_size][/center]")
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Player Position: " + str(player.position) + "[/font][/font_size][/center]")
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Head Y-Axis Rotation: " + str(playerHead.rotation_degrees.y) + "[/font][/font_size][/center]")
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Camera X-Axis Rotation: " + str(playerCamera.rotation_degrees.x) + "[/font][/font_size][/center]")
			else:
				printerr("[PlayerData] Player node not found. LoadData failed. 
				THIS MAY BE DUE TO YOUR PLAYER SCENE NOT BEING INSTANTIATED PROPERLY! 
				THE LOCAL DIRECTORY USED FOR RETRIEVING THE PLAYER NODE IS IN /root/World/Player. 
				THIS MEANS THAT YOUR SCENE NEEDS A ROOT NODE CALLED 'World' 
				AND THE PLAYER NEEDS TO BE A CHILD OF THAT ROOT NODE AND CALLED 'Player'.")
		file.close()
