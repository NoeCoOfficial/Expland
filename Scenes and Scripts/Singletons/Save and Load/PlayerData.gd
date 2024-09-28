# ============================================================= #
# PlayerData.gd [AUTOLOAD]
# ============================================================= #
#                       COPYRIGHT NOTICE                        #
#                           Noe Co.                             #
#                   2024 - All Rights Reserved                  #
#                                                               #
#                         MIT License                           #
#                                                               #
# Permission is hereby granted, free of charge, to any          #
# person obtaining a copy of this software and associated       #
# documentation files (the "Software"), to deal in the          #
# Software without restriction, including without limitation    #
# the rights to use, copy, modify, merge, publish, distribute,  #
# sublicense, and/or sell copies of the Software, and to        #
# permit persons to whom the Software is furnished to do so,    #
# subject to the following conditions:                          #
#                                                               #
# 1. The above copyright notice and this permission notice      #
#    shall be included in all copies or substantial portions    #
#    of the Software.                                           #
#                                                               #
# 2. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF      #
#    ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED    #
#    TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A        #
#    PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL  #
#    THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,  #
#    DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF        #
#    CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN    #
#    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER           #
#    DEALINGS IN THE SOFTWARE.                                  #
#                                                               #
#                   For inquiries, contact:                     #
#                  noeco.official@gmail.com                     #
# ============================================================= #

extends Node

const SAVE_PATH = "res://player.dat"

var GAME_STATE = "NORMAL"
var Health := 100

func _ready():
	printerr("PlayerData autoload ready")

func SaveData() -> void:
	var player = get_node("/root/World/Player")
	var playerHead = get_node("/root/World/Player/Head")
	var playerCamera = get_node("/root/World/Player/Head/Camera3D")
	
	if player:
		var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		var data = {
			"GAME_STATE": GAME_STATE,
			"Health": Health,
			"Position": vector3_to_dict(player.position),
			"HeadRotationY": playerHead.rotation_degrees.y,  # Save only Y rotation for the head
			"CameraRotationX": playerCamera.rotation_degrees.x  # Save only X rotation for the camera
		}
		var jstr = JSON.stringify(data)
		file.store_line(jstr)
		file.close()
		print("--Saved Player Data--")
	else:
		printerr("Player node not found. SaveData failed.")


func LoadData() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		push_warning("File doesn't exist (" + SAVE_PATH + ")")
		return
	
	if file and not file.eof_reached():
		var current_line = JSON.parse_string(file.get_line())
		if current_line:
			
			Health = current_line["Health"]
			GAME_STATE = current_line["GAME_STATE"]
			
			var player = get_node("/root/World/Player")
			var playerHead = get_node("/root/World/Player/Head")
			var playerCamera = get_node("/root/World/Player/Head/Camera3D")
				
			if player:
				
				
				player.position = dict_to_vector3(current_line["Position"]) ## Player Position
				
				playerHead.rotation_degrees.y = current_line["HeadRotationY"] ## Restore head rotation (only Y-axis)
				
				playerCamera.rotation_degrees.x = current_line["CameraRotationX"] ## Restore camera rotation (only X-axis)
				
				
				
				print_rich("[center][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Black.otf][font_size=30]--PLAYER DATA HAS BEEN LOADED--[/font_size][/font][/center]")
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Health: " + str(Health) + "[/font][/font_size][/center]")
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Game State: " + GAME_STATE + "[/font][/font_size][/center]")
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Player Position: " + str(player.position) + "[/font][/font_size][/center]")
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Head Y-Axis Rotation: " + str(playerHead.rotation_degrees.y) + "[/font][/font_size][/center]")
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Camera X-Axis Rotation: " + str(playerCamera.rotation_degrees.x) + "[/font][/font_size][/center]")
			else:
				printerr("Player node not found. LoadData failed. 
				THIS MAY BE DUE TO YOUR PLAYER SCENE NOT BEING INSTANTIATED PROPERLY! 
				THE LOCAL DIRECTORY USED FOR RETRIEVING THE PLAYER NODE IS IN /root/World/Player. 
				THIS MEANS THAT YOUR SCENE NEEDS A ROOT NODE CALLED 'World' 
				AND THE PLAYER NEEDS TO BE A CHILD OF THAT ROOT NODE AND CALLED 'Player'.")
		file.close()



# utils
func vector3_to_dict(vec: Vector3) -> Dictionary:
	return {"x": vec.x, "y": vec.y, "z": vec.z}

func dict_to_vector3(dict: Dictionary) -> Vector3:
	return Vector3(dict["x"], dict["y"], dict["z"])
