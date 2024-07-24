extends Node

const SAVE_PATH = "res://settings.dat"

var FOV = 100




var SaveData = {
	# SETTINGS #
	"FOV" : FOV,
	
}

func SaveSettings() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data = {
		
		"FOV" : FOV,
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)
	print("--Saved Player Settings--")
func LoadSettings() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		push_warning("File doesn't exist (" + SAVE_PATH + ")")
		return
	if file == null:
		return
	if FileAccess.file_exists(SAVE_PATH) == true:
		if not file.eof_reached():
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				FOV = current_line["FOV"]
				print_rich("[center][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Black.otf][font_size=30]--PLAYER SETTINGS HAVE BEEN LOADED--[/font_size][/font][/center]")
				
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]FOV: "+str(FOV)+"[/font][/font_size][/center]")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
