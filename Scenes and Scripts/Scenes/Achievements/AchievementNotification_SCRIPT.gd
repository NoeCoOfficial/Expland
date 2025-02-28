# ============================================================= #
# AchievementNotification_SCRIPT.gd
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

@icon("res://Textures/Icons/Script Icons/32x32/warning.png")
extends Control

var animation

func spawnAchievementsNotification(ARR_INDEX : int):
	AchievementsManager.NotificationOnScreen = true
	if animation:
		animation.kill()
	animation = get_tree().create_tween().set_parallel()
	$DespawnTimer.start()
	
	updateNotification(ARR_INDEX, "res://Textures/Achievements/" + AchievementsManager.ACHIEVEMENTS[ARR_INDEX] + ".png")
	
	animation.tween_property($LightBG, "position:x", -215, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	animation.tween_property($DarkBG, "position:x", -211, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(0.2)
	animation.tween_property($Elements, "position:x", -159, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(0.2)

func despawnAchievementsNotification():
	AchievementsManager.NotificationOnScreen = false
	animation = get_tree().create_tween().set_parallel()
	animation.tween_property($LightBG, "position:x", 0, 0.7).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO).set_delay(0.2)
	animation.tween_property($DarkBG, "position:x", 4, 0.7).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	animation.tween_property($Elements, "position:x", 56, 0.7).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)

func updateNotification(ARR_INDEX: int, e_image_path: String):
	$DespawnTimer.start()
	$Elements/AchievementName.text = str(AchievementsManager.ACHIEVEMENTS[ARR_INDEX]).capitalize()
	
	var texture = load(e_image_path)  # Directly load the image as a texture
	if texture is Texture2D:  # Ensure it's a valid texture
		$Elements/e_image_container/e_image.texture = texture
	else:
		print("Failed to load texture:", e_image_path)
	

func resetDespawnTimer():
	$DespawnTimer.stop()
	$DespawnTimer.start()

func _on_despawn_timer_timeout() -> void:
	despawnAchievementsNotification()
