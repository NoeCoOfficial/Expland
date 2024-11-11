# ============================================================= #
# PlayerSettingsData.gd [AUTOLOAD]
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

const SAVE_PATH = "res://settings.dat"

var FOV = 100
var music_Volume = 1
var sfx_Volume = 1
var Master_Volume = 1

func saveSettings() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data = {
		"sfx_Volume" : sfx_Volume,
		"music_Volume" : music_Volume,
		"Master_Volume" :Master_Volume,
		"FOV" : FOV,
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)
	print("[PlayerSettingsData] --Saved Player Settings--")

func loadSettings() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		push_warning("[PlayerSettingsData] File doesn't exist (" + SAVE_PATH + ")")
		return
	if file == null:
		return
	if FileAccess.file_exists(SAVE_PATH) == true:
		if not file.eof_reached():
			
			
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				FOV = current_line["FOV"]
				Master_Volume = current_line["Master_Volume"]
				music_Volume = current_line["music_Volume"]
				sfx_Volume = current_line["sfx_Volume"]
				
				print_rich("[center][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Black.otf][font_size=30]-- PLAYER SETTINGS HAVE BEEN LOADED --[/font_size][/font][/center]")
				
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]FOV: "+str(FOV)+"[/font][/font_size][/center]")
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Master Volume: "+str(Master_Volume)+"[/font][/font_size][/center]")
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Music Volume: "+str(music_Volume)+"[/font][/font_size][/center]")
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]SFX Volume: "+str(sfx_Volume)+"[/font][/font_size][/center]")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
