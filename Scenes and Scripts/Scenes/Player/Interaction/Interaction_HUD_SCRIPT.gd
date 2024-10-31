# ============================================================= #
# Interaction_HUD_SCRIPT.gd
# ============================================================= #
#                       COPYRIGHT NOTICE                        #
#                           Noe Co.                             #
#                   2024 - All Rights Reserved                  #
#                                                               #
#                         MIT License                           #
#                                                               #
# Permission is hereby granted, free of charge, to any          #
# person obtaining a copy of this software and associated       #
# documentation files (the "Software"), to deal in the          #
# Software without restriction, including without limitation    #
# the rights to use, copy, modify, merge, publish, distribute,  #
# sublicense, and/or sell copies of the Software, and to        #
# permit persons to whom the Software is furnished to do so,    #
# subject to the following conditions:                          #
#                                                               #
# 1. The above copyright notice and this permission notice      #
#    shall be included in all copies or substantial portions    #
#    of the Software.                                           #
#                                                               #
# 2. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF      #
#    ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED    #
#    TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A        #
#    PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL  #
#    THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,  #
#    DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF        #
#    CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN    #
#    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER           #
#    DEALINGS IN THE SOFTWARE.                                  #
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
