# ============================================================= #
# InteractionManager.gd [AUTOLOAD]
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

var is_notification_on_screen = false
var is_colliding = false

var is_hovering_over_email_noeco = false
var is_hovering_over_feedback_github = false
var is_hovering_over_test_obj = false
var is_hovering_over_sackcloth_bed = false
var is_hovering_over_chest = false
var is_hovering_over_workbench = false

func spawn_interaction_notification(KEY : String, MESSAGE : String):
	if !is_notification_on_screen:
		var interaction_node = get_node("/root/World/Player/Head/Camera3D/InteractionLayer/InteractionHUD")
		if interaction_node.has_method("ShowNotification"):
			interaction_node.ShowNotification(KEY, MESSAGE)
			is_notification_on_screen = true
			print("[InteractionManager] Spawned interaction notification")
			print("Key: " + KEY)
			print("Message: " + MESSAGE)

func despawn_interaction_notification():
	if is_notification_on_screen:
		var interaction_node = get_node("/root/World/Player/Head/Camera3D/InteractionLayer/InteractionHUD")
		if interaction_node.has_method("HideNotification"):
			interaction_node.HideNotification()
			is_notification_on_screen = false
			print("[InteractionManager] Despawned interaction notification")

func _input(_event: InputEvent) -> void:
	if !PlayerData.GAME_STATE == "SLEEPING" and !InventoryManager.in_chest_interface and !PlayerData.GAME_STATE == "DEAD" and !PlayerData.GAME_STATE == "SLEEPING" and !InventoryManager.is_in_workbench_interface and !InventoryManager.inventory_open and !PauseManager.is_paused:
		if Input.is_action_just_pressed("Interact") and is_hovering_over_test_obj:
			pass
		
		if Input.is_action_just_pressed("Interact") and is_hovering_over_email_noeco:
			OS.shell_open("https://mail.google.com/mail/?view=cm&fs=1&to=noeco.official@gmail.com")
		
		if Input.is_action_just_pressed("Interact") and is_hovering_over_feedback_github:
			OS.shell_open("https://github.com/NoeCoOfficial/Expland/issues/new?assignees=&labels=&projects=&template=feedback.md")
		
		if Input.is_action_just_pressed("Interact") and is_hovering_over_sackcloth_bed and PlayerData.GAME_STATE != "SLEEPING":
			if TimeManager.DAY_STATE != "DAY":
				PlayerManager.sleep()
				despawn_interaction_notification()
			else:
				PlayerManager.PLAYER.spawn_minimal_alert_from_player(2.0, 0.1, 0.5, "You can only sleep at night.")
		
		if Input.is_action_just_pressed("Interact") and is_hovering_over_chest:
			if !InventoryManager.chestNode.is_animating():
				PlayerManager.PLAYER.openChest()
			
		if Input.is_action_just_pressed("Interact") and is_hovering_over_workbench:
			PlayerManager.PLAYER.openChest()
			
