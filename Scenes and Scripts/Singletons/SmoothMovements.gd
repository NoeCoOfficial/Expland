# ============================================================= #
# SmoothMovements.gd [AUTOLOAD]
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
