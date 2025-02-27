# ============================================================= #
# AchievementsManager.gd [AUTOLOAD]
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

var NotificationOnScreen = false
var CURRENT_NOTIFICATION_NODE
var CURRENT_UI_GRID_CONTAINER

var ACHIEVEMENTS = [
	"PLACEHOLDER",
	
	# =================== #
	
	"CHALLENGER", # Beat story mode for the first time (1)
	"VETERAN", # Beat story mode for the tenth time (2)
	
	"WANDERER", # Beat free mode for the first time (3)
	"NOMAD", # Beat free mode for the tenth time (4)
	
	"SKILLED", # Beat parkour mode for the first time (5)
	"FREE RUN", # Beat parkour mode for the tenth time (6)
	
	"NEW LIFE", # Visisted The Island for the first time (7)
	"BED TIME", # Slept for the first time (8)
	"SURVIVOR", # Survived the night for the first time (9)
	
	"EXORCIST", # Defeat The Eryv for the first time (10)
	"HUNTER", # Defeat The Eryv for the tenth time (11)
	
	"SECRET", # You found a secret! (#)
	
]

var ACHIEVEMENT_DESCRIPTIONS = [
	"PLACEHOLDER",
	
	# =================== #
	
	"Beat Story Mode for the first time.", # CHALLENGER (1)
	"Beat Story Mode for the tenth time.", # VETERAN (2)
	
	"Beat Free Mode for the first time.", # WANDERER (3)
	"Beat Free Mode for the tenth time.", # NOMAD (4)
	
	"Beat Parkour Mode for the first time.", # SKILLED (5)
	"Beat Parkour Mode for the tenth time.", # FREE RUN (6)
	
	"Visited The Island for the first time.", # NEW LIFE (7)
	"Slept for the first time.", # BED TIME (8)
	"Survived the night for the first time.", # SURVIVOR (9)

	"Defeat The Eryv for the first time.", # EXORCIST (10)
	"Defeat The Eryv for the tenth time.", # HUNTER (11)
	
	"You found a secret!", # SECRET (#)
]

var EARNED_ACHIEVEMENTS = []

func earnAchievement(ARR_INDEX : int, withNotification : bool):
	var info = []
	
	var unix_time = Time.get_unix_time_from_system()
	var date_dict = Time.get_date_dict_from_unix_time(unix_time)
	var formatted_date = "%02d/%02d/%d" % [date_dict.day, date_dict.month, date_dict.year]
	
	info.append(ARR_INDEX)
	info.append(formatted_date)
	
	EARNED_ACHIEVEMENTS.append(info)
	
	if CURRENT_NOTIFICATION_NODE:
		if withNotification:
			CURRENT_NOTIFICATION_NODE.spawnAchievementsNotification(ARR_INDEX)
	
	if CURRENT_UI_GRID_CONTAINER:
		pass
