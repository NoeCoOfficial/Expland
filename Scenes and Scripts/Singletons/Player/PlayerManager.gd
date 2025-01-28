# ============================================================= #
# PlayerManager.gd [AUTOLOAD]
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

var WORLD = null
var PLAYER = null
var INVENTORY_LAYER = null
var CHEST_SLOTS = null
var MINIMAL_ALERT_PLAYER = null

var AudioNotification

var SLEEPING_UPON_ENTERED = false
var Stamina : float = 100.0

func init():
	WORLD = get_node("/root/World/")
	PLAYER = get_node("/root/World/Player/")
	CHEST_SLOTS = get_node("/root/World/Player/Head/Camera3D/InventoryLayer/InventoryMainLayer/ChestMainLayer/ChestSlots")
	INVENTORY_LAYER = get_node("/root/World/Player/Head/Camera3D/InventoryLayer")
	MINIMAL_ALERT_PLAYER = get_node("/root/World/Player//Head/Camera3D/MinimalAlertLayer/MinimalAlert")

func sleep():
	if PLAYER != null:
		PLAYER.sleep_cycle(true, true, 2.0, 5.0, 2.0, 360)

func eat(valueToIncreaseBy):
	if PLAYER != null:
		
		var final_hunger_value = valueToIncreaseBy + PlayerData.Hunger
		
		if final_hunger_value >= 100:
			final_hunger_value = 100
		
		PlayerData.Hunger = final_hunger_value
		PLAYER.update_bar("HUNGER", true, PlayerData.Hunger)
