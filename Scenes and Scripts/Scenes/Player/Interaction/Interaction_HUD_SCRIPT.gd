# ============================================================= #
# Interaction_HUD_SCRIPT.gd
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

extends Control

func ShowNotification(KEY : String, MESSAGE : String):
	ShowLighterBG_NOTIFICATION()
	ShowContents_NOTIFICATION(KEY, MESSAGE)

func ShowLighterBG_NOTIFICATION():
	var tween = get_tree().create_tween()
	tween.tween_property($LighterBG, "position:x", 228.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func ShowContents_NOTIFICATION(KEY : String, MESSAGE : String):
	var tween = get_tree().create_tween()
	$Contents/KEY.text = KEY
	$Contents/MESSAGE.text = MESSAGE
	tween.tween_property($Contents, "position:x", 228.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func HideNotification():
	HideLighterBG_NOTIFICATION()
	HideContents_NOTIFICATION()

func HideLighterBG_NOTIFICATION():
	var tween = get_tree().create_tween()
	tween.tween_property($LighterBG, "position:x", -228, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)

func HideContents_NOTIFICATION():
	var tween = get_tree().create_tween()
	tween.tween_property($Contents, "position:x", -228, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
