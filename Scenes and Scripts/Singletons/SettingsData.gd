extends Node

const SAVE_PATH = "res://settings.dat"

var FOV = 88




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

func LoadSettings() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		print("File doesn't exist (" + SAVE_PATH + ")")
		return
	if file == null:
		return
	if FileAccess.file_exists(SAVE_PATH) == true:
		if not file.eof_reached():
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				print("--Loaded Settings--")
				FOV = current_line["FOV"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
