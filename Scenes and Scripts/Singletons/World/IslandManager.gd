# ============================================================= #
# IslandManager.gd [AUTOLOAD]
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

extends Node

var transitioning_from_menu
var transitioningFromNewIsland = false
var FreeMode_Island_Count : int

var Current_Island_Name = "Debug"
var Current_Game_Mode = "FREE"

func _ready() -> void:
	if !OS.is_debug_build():
		Current_Island_Name = ""

func resetAttributes():
	
	# CRITICAL
	# EVERY VALUE ASSOCIATED WITH THE ISLAND AND/OR PLAYER
	# IT'S NAME AND IT'S DEFAULT VALUE MUST BE SET HERE!
	# VERY IMPORTANT!
	
	PauseManager.inside_can_move_item_workshop = false
	PauseManager.inside_absolute_item_workshop = false
	PauseManager.inside_item_workshop = false
	PauseManager.is_inside_achievements_ui = false
	PauseManager.is_inside_alert = false
	PauseManager.is_inside_credits = false
	PauseManager.is_inside_settings = false
	PauseManager.is_paused = false
	
	EffectManager.Current_Effects = []
	
	PlayerData.GAME_STATE = "NORMAL"
	PlayerData.Health = 100
	PlayerData.Hunger = 100
	PlayerManager.Stamina = 100
	IslandManager.Current_Island_Name = ""
	IslandManager.Current_Game_Mode = ""
	IslandManager.transitioningFromNewIsland = false
	TimeManager.CURRENT_TIME = 600
	TimeManager.CURRENT_DAY = 1
	TimeManager.DAY_STATE = "DAY"
	
	WeatherManager.CURRENT_WEATHER = ""
	WeatherManager.CURRENT_WEATHER_ARR_INDEX = 0
	WeatherManager.WEATHER_TIMER_TIME_LEFT = 0
	
	ExplorerNotesManager.COLLECTED_NOTES.clear()
	
	AchievementsManager.NotificationOnScreen = false
	
	TerrainManager.on_terrain = ""
	
