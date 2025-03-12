# ============================================================= #
# WeatherManager.gd [AUTOLOAD]
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

var CURRENT_WEATHER : String = ""
var CURRENT_WEATHER_ARR_INDEX : int

var WEATHERS : Array = [
	"SUNNY", # 0
	"CLOUDY", # 1
	"RAIN", # 2
	"LIGHT_RAIN", # 3
	"STORM", # 4
]

# Define weights for each weather type
var WEATHER_WEIGHTS : Array = [50, 20, 20, 5, 5]

func get_random_weather() -> int:
	var total_weight = 0
	for weight in WEATHER_WEIGHTS:
		total_weight += weight
	
	var random_value = randi() % total_weight
	var cumulative_weight = 0
	
	for i in range(WEATHER_WEIGHTS.size()):
		cumulative_weight += WEATHER_WEIGHTS[i]
		if random_value < cumulative_weight:
			return i
	
	return 0 # Default to SUNNY if something goes wrong

func change_weather_to_random():
	var random_weather_index = get_random_weather()
	change_weather(random_weather_index)

func change_weather(ARR_INDEX : int):
	if ARR_INDEX < 0 or ARR_INDEX >= WEATHERS.size():
		print("Invalid array index for accessing weather! " + str(ARR_INDEX))
		return
	
	var PREV_WEATHER = CURRENT_WEATHER
	CURRENT_WEATHER = WEATHERS[ARR_INDEX]
	CURRENT_WEATHER_ARR_INDEX = ARR_INDEX
	
	if PlayerManager.WORLD:
		PlayerManager.WORLD.change_weather(CURRENT_WEATHER, PREV_WEATHER)
