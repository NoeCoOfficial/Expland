extends Node

const SAVE_PATH = "res://player.dat"

var Health := 100

func SaveData() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data = {
		
		"Health" : Health,
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)
	print("--Saved Player Settings--")

func LoadData() -> void:
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
				Health = current_line["Health"]
				print_rich("[center][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Black.otf][font_size=30]--PLAYER DATA HAS BEEN LOADED--[/font_size][/font][/center]")
				
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Health: "+str(Health)+"[/font][/font_size][/center]")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
