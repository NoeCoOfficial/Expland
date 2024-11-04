# ============================================================= #
# TransitionManager.gd [AUTOLOAD]
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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func ChangeSceneWithAnimation(sceneToChangeTo, animationOrigin : String, animationTime : float, pathToDarkOverlay, pathToLightOverlay):

	if load(sceneToChangeTo) != null:
		if pathToDarkOverlay == null or pathToLightOverlay == null:

			if get_node("/root/World/Player/Head/Camera3D/TransitionLayer/DarkGreyOverlay") != null and get_node("/root/World/Player/Head/Camera3D/TransitionLayer/LightGreyOverlay") != null:
				
				print("[TransitionManager] Using player transition overlay.")

				var SceneChangeDarkGreyOverlay = get_node("/root/World/Player/Head/Camera3D/TransitionLayer/DarkGreyOverlay")
				var SceneChangeLightGreyOverlay = get_node("/root/World/Player/Head/Camera3D/TransitionLayer/LightGreyOverlay")
				

				if animationOrigin == "TOP":

					SceneChangeDarkGreyOverlay.position = Vector2(0, 0)
					SceneChangeLightGreyOverlay.position = Vector2(0, 0)
					
					print("[TransitionManager] Animating from player node from origin: TOP")

					animateColorRect_IN(SceneChangeLightGreyOverlay, 0.0, 0.0, animationTime, "EXPO")
					await get_tree().create_timer(0.3).timeout
					animateColorRect_IN(SceneChangeDarkGreyOverlay, 0.0, 0.0, animationTime, "EXPO")

				elif animationOrigin == "BOTTOM":
					
					SceneChangeDarkGreyOverlay.position = Vector2(0, 648)
					SceneChangeLightGreyOverlay.position = Vector2(0, 648)
					
					print("[TransitionManager] Animating from player node from origin: BOTTOM")
					
					animateColorRect_IN(SceneChangeLightGreyOverlay, 0.0, 0.0, animationTime, "EXPO")
					await get_tree().create_timer(0.3).timeout
					animateColorRect_IN(SceneChangeDarkGreyOverlay, 0.0, -9.0, animationTime, "EXPO")

				else:
					printerr('[TransitionManager] Error getting animationOrigin, please use only "TOP" or "BOTTOM" for the parameter.')


		else:
			pass
			# create ColorRect from path logic
	else:
		printerr("[TransitionManager] Failed loading scene: " + str(sceneToChangeTo))





func animateColorRect_IN(colorRectNode, x : float, y : float, animationTime : float, animationType : String):
	var typeOfAnimation

	if animationType == "BOUNCE":
		typeOfAnimation = Tween.TRANS_BOUNCE
	elif animationType == "EXPO":
		typeOfAnimation = Tween.TRANS_EXPO

	var tween = get_tree().create_tween()
	tween.tween_property(colorRectNode, "position", Vector2(x, y), animationTime).set_ease(Tween.EASE_OUT).set_trans(typeOfAnimation)