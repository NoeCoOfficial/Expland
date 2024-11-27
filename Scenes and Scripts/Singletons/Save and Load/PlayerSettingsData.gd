# ============================================================= #
# PlayerSettingsData.gd [AUTOLOAD]
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

@icon("res://Textures/Icons/Script Icons/32x32/settings_save.png")
extends Node

const SAVE_PATH = "res://settings.dat"

######################################
# General
######################################



######################################
# Graphics
######################################

var MotionBlur = true

######################################
# Video

######################################
var FOV = 100

######################################
# Audio
######################################

var music_Volume = 1
var sfx_Volume = 1
var Master_Volume = 1

######################################
# Data persistence
######################################

func saveSettings() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data = {
		"motion_blur" : MotionBlur,
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
				MotionBlur = current_line["motion_blur"]
				FOV = current_line["FOV"]
				Master_Volume = current_line["Master_Volume"]
				music_Volume = current_line["music_Volume"]
				sfx_Volume = current_line["sfx_Volume"]
				
				print_rich("[center][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Black.otf][font_size=30]-- PLAYER SETTINGS HAVE BEEN LOADED --[/font_size][/font][/center]")
				
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]FOV: "+str(FOV)+"[/font][/font_size][/center]")
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Master Volume: "+str(Master_Volume)+"[/font][/font_size][/center]")
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Music Volume: "+str(music_Volume)+"[/font][/font_size][/center]")
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]SFX Volume: "+str(sfx_Volume)+"[/font][/font_size][/center]")
				print_rich("[center][font_size=15][font=res://Fonts/CabinetGrotesk/CabinetGrotesk-Bold.otf]Motion Blur: "+str(MotionBlur)+"[/font][/font_size][/center]")

func set_motion_blur(value : bool) -> void:
	if value:
		MotionBlur = true
		var world = get_node("/root/World")
		
		if world.has_method("set_motion_blur"):
			world.set_motion_blur(value)
		else:
			printerr("[PlayerSettingsData] Could not find set_motion_blur() method in world node.")
	else:
		MotionBlur = false
		var world = get_node("/root/World")
		
		if world.has_method("set_motion_blur"):
			world.set_motion_blur(value)
		else:
			printerr("[PlayerSettingsData] Could not find set_motion_blur() method in world node.")
