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

const SAVE_PATH = "user://saveData/settings.xpldcfg"

######################################
# General
######################################

var showStartupScreen : bool = true
var autosaveInterval : int = 60

var quickAnimations : bool = false
# TODO: Do this setting
var showTime : bool = false

######################################
# Graphics
######################################

var DOFBlur : bool = true
var PrettyShadows : bool = false

######################################
# Video
######################################

var FOV : int = 110
var Sensitivity : float = 0.001

######################################
# Audio
######################################

var music_Volume = 1
var sfx_Volume = 1
var Master_Volume = 1

######################################
# Data persistence
######################################

func saveSettings(save_path: String, SK : String):
	# Make sure path exists
	SaveManager.verify_dir("saveData")
	var target_file = FileAccess.open_encrypted_with_pass(
		save_path, 
		FileAccess.WRITE,
		SK)
	
	if target_file == null:
		print(FileAccess.get_open_error())
		return
	
	var data = {
		
		# General
		"showStartupScreen" : showStartupScreen,
		"autosaveInterval" : autosaveInterval,
		"quickAnimations" : quickAnimations,
		"showTime" : showTime,
		
		# Graphics
		"DOFBlur" : DOFBlur,
		"PrettyShadows" : PrettyShadows,
		
		# Video
		"FOV" : FOV,
		"Sensitivity" : Sensitivity,
		
		# Audio
		"sfx_Volume" : sfx_Volume,
		"music_Volume" : music_Volume,
		"Master_Volume" : Master_Volume,
		
	}
	
	var json_data_string = JSON.stringify(data, "\t")
	target_file.store_string(json_data_string)
	target_file.close()

func loadSettings(save_path: String, SK : String):
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open_encrypted_with_pass(
			save_path, 
			FileAccess.READ,
			SK)
		
		if file == null:
			print(FileAccess.get_open_error())
			return
		
		var content = file.get_as_text()
		file.close()
		
		var data = JSON.parse_string(content)
		if data == null:
			printerr("Cannot parse %s as a json_string: (%s)" % [save_path, content])
			return
		
		showStartupScreen = data.showStartupScreen
		autosaveInterval = data.autosaveInterval
		quickAnimations = data.quickAnimations
		showTime = data.showTime
		
		DOFBlur = data.DOFBlur
		PrettyShadows = data.PrettyShadows
		
		FOV = data.FOV
		Sensitivity = data.Sensitivity
		
		sfx_Volume = data.sfx_Volume
		music_Volume = data.music_Volume
		Master_Volume = data.Master_Volume
		
	else:
		printerr("Cannot open non-existent file at %s!" % [save_path])

######################################
# Setting values
######################################

func set_autosave_interval(value : int):
	if PlayerManager.PLAYER != null:
		PlayerManager.PLAYER.setAutosaveInterval(value)

func set_dof_blur(value : bool) -> void:
	if !StoryModeManager.is_in_story_mode_first_cutscene_world:
		if get_node("/root/World") != null:
				if value:
					DOFBlur = true
					var world = get_node("/root/World")
					
					if world.has_method("set_dof_blur"):
						world.set_dof_blur(value)
					else:
						printerr("[PlayerSettingsData] Could not find set_dof_blur() method in world node.")
				else:
					DOFBlur = false
					var world = get_node("/root/World")
					
					if world.has_method("set_dof_blur"):
						world.set_dof_blur(value)
					else:
						printerr("[PlayerSettingsData] Could not find set_dof_blur() method in world node.")
		else:
			printerr("[PlayerSettingsData] World node (/root/World) is null. Can't call set_dof_blur().")

func set_pretty_shadows(value : bool) -> void:
	if !StoryModeManager.is_in_story_mode_first_cutscene_world:
		if get_node("/root/World") != null:
				if value:
					PrettyShadows = true
					var world = get_node("/root/World")
					
					if world.has_method("set_pretty_shadows"):
						world.set_pretty_shadows(value)
					else:
						printerr("[PlayerSettingsData] Could not find set_pretty_shadows() method in world node.")
				else:
					PrettyShadows = false
					var world = get_node("/root/World")
					
					if world.has_method("set_pretty_shadows"):
						world.set_pretty_shadows(value)
					else:
						printerr("[PlayerSettingsData] Could not find set_pretty_shadows() method in world node.")
		else:
			printerr("[PlayerSettingsData] World node (/root/World) is null. Can't call set_pretty_shadows().")
