# ============================================================= #
# SmoothMovements.gd [AUTOLOAD]
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

func SmoothScreenONOFF(node : Node, transTYPE : String, transTIME : float, ONorOFF : String, HasCenteredOffset : bool):

	if HasCenteredOffset == true:
		pass
	else:
		var node_size = node.get_size()
		node.set_pivot_offset(Vector2(node_size/2))

	if ONorOFF == "ON":
		if transTYPE == "TOP":
			var tween = get_tree().create_tween()
			tween.tween_property(node, "position", Vector2(0, 0), transTIME).from(Vector2(0, -648)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		elif transTYPE == "BOTTOM":
			var tween = get_tree().create_tween()
			tween.tween_property(node, "position", Vector2(0, 0), transTIME).from(Vector2(0, 648)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		elif transTYPE == "LEFT":
			var tween = get_tree().create_tween()
			tween.tween_property(node, "position", Vector2(0, 0), transTIME).from(Vector2(-1152, 0)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		elif transTYPE == "RIGHT":
			var tween = get_tree().create_tween()
			tween.tween_property(node, "position", Vector2(0, 0), transTIME).from(Vector2(1152, 0)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		elif transTYPE == "ZOOM":
			var tween = get_tree().create_tween().set_parallel()
			tween.tween_property(node, "position", Vector2(0, 0), 0)
			tween.tween_property(node, "scale", Vector2(1, 1), transTIME).from(Vector2(0, 0)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

	elif ONorOFF == "OFF":
		if transTYPE == "TOP":
			var tween = get_tree().create_tween()
			tween.tween_property(node, "position", Vector2(0, -648), transTIME).from(Vector2(0, 0)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		elif transTYPE == "BOTTOM":
			var tween = get_tree().create_tween()
			tween.tween_property(node, "position", Vector2(0, 648), transTIME).from(Vector2(0, 0)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		elif transTYPE == "LEFT":
			var tween = get_tree().create_tween()
			tween.tween_property(node, "position", Vector2(-1152, 0), transTIME).from(Vector2(0, 0)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		elif transTYPE == "RIGHT":
			var tween = get_tree().create_tween()
			tween.tween_property(node, "position", Vector2(1152, 0), transTIME).from(Vector2(0, 0)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		elif transTYPE == "ZOOM":
			var tween = get_tree().create_tween().set_parallel()
			tween.tween_property(node, "position", Vector2(0, 0), 0)
			tween.tween_property(node, "scale", Vector2(0, 0), transTIME).from(Vector2(1, 1)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		
	else:
		print("Only accepting 'ON' or 'OFF' for ONorOFF parameter.")
		print("Please pass a valid parameter.")


func SmoothCameraTOXY(x, y, TIME, CameraNode : Node):
	var tween = get_tree().create_tween()
	tween.tween_property(CameraNode, "position", Vector2(x, y), TIME).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
