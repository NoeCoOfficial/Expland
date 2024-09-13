extends Node

const SAVE_PATH = "res://player.dat"

var GAME_STATE = "NORMAL"
var Health := 100

func _ready():
	printerr("PlayerData autoload ready")

func SaveData() -> void:
	var player = get_node("/root/World/Player")
	var playerCamera = get_node("/root/World/Player/Head/Camera3D")
	
	if player:
		var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		var data = {
			"GAME_STATE": GAME_STATE,
			"Health": Health,
			"Position": vector3_to_dict(player.position),
			"CameraRotationDegrees": vector3_to_dict(playerCamera.rotation_degrees)  # Save full rotation in degrees
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
			var playerCamera = get_node("/root/World/Player/Head/Camera3D")
				
			if player:
				# Restore player position
				player.position = dict_to_vector3(current_line["Position"])
				
				# Debugging: Check the stored rotation
				print("Loaded Camera Rotation in Degrees (raw data): ", current_line["CameraRotationDegrees"])
				
				# Restore the full camera rotation in degrees
				var loaded_rotation_degrees = dict_to_vector3(current_line["CameraRotationDegrees"])
				
				# Debugging: Check the restored rotation
				print("Applying Camera Rotation in Degrees: ", loaded_rotation_degrees)
				
				# Apply rotation to camera in degrees
				playerCamera.rotation_degrees = loaded_rotation_degrees
				
				# Rich text display for loaded data
				print_rich("[center][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Black.otf][font_size=30]--PLAYER DATA HAS BEEN LOADED--[/font_size][/font][/center]")
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Health: " + str(Health) + "[/font][/font_size][/center]")
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Game State: " + GAME_STATE + "[/font][/font_size][/center]")
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Player Position: " + str(player.position) + "[/font][/font_size][/center]")
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Player Camera Rotation: " + str(playerCamera.rotation_degrees) + "[/font][/font_size][/center]")
			else:
				print("Player node not found. LoadData failed.")
		file.close()


# utils
func vector3_to_dict(vec: Vector3) -> Dictionary:
	return {"x": vec.x, "y": vec.y, "z": vec.z}

func dict_to_vector3(dict: Dictionary) -> Vector3:
	return Vector3(dict["x"], dict["y"], dict["z"])
