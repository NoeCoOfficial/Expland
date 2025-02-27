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
	
	$Elements/AchievementName.text = AchievementsManager.ACHIEVEMENTS[ARR_INDEX]
	
	animation.tween_property($LightBG, "position:x", -193, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	animation.tween_property($DarkBG, "position:x", -189, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(0.2)
	animation.tween_property($Elements, "position:x", -193, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(0.2)

func despawnAudioNotification():
	AudioManager.NotificationOnScreen = false
	animation = get_tree().create_tween().set_parallel()
	animation.tween_property($LightBG, "position:x", 0, 0.7).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO).set_delay(0.2)
	animation.tween_property($DarkBG, "position:x", 0, 0.7).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	animation.tween_property($Elements, "position:x", 0, 0.7).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)

func updateNotification(paused : bool, songName : String):
	$DespawnTimer.start()
	$Elements/SongName.text = songName
	
	if AudioManager.PREVIOUS_SONGS.is_empty():
		$Elements/PreviousBtnIcon.hide()
		$"Elements/J Key Container".hide()
	else:
		$Elements/PreviousBtnIcon.show()
		$"Elements/J Key Container".show()
	
	if paused:
		$Elements/PauseBtnIcon.visible = false
		$Elements/PlayBtnIcon.visible = true
	else:
		$Elements/PauseBtnIcon.visible = true
		$Elements/PlayBtnIcon.visible = false

func resetDespawnTimer():
	$DespawnTimer.stop()
	$DespawnTimer.start()

func _on_despawn_timer_timeout() -> void:
	despawnAudioNotification()
