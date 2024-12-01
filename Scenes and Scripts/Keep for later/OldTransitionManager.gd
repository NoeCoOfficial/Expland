# ============================================================= #
# TransitionManager.gd [AUTOLOAD]
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

func ChangeSceneWithAnimation(sceneToChangeTo, animationOrigin : String, animationTime : float, pathToDarkOverlay, pathToLightOverlay):

	if load(sceneToChangeTo) != null:
		if pathToDarkOverlay == null or pathToLightOverlay == null:

			if get_node("/root/World/Player/Head/Camera3D/TransitionLayer/DarkGreyOverlay") != null and get_node("/root/World/Player/Head/Camera3D/TransitionLayer/LightGreyOverlay") != null:
				
				print("[TransitionManager] Using player transition overlay.")

				var SceneChangeDarkGreyOverlay = get_node("/root/World/Player/Head/Camera3D/TransitionLayer/DarkGreyOverlay")
				var SceneChangeLightGreyOverlay = get_node("/root/World/Player/Head/Camera3D/TransitionLayer/LightGreyOverlay")
				

				if animationOrigin == "TOP":

					SceneChangeDarkGreyOverlay.position = Vector2(0, -1500)
					SceneChangeLightGreyOverlay.position = Vector2(0, -1500)
					
					print("[TransitionManager] Animating from player node from origin: TOP")

					var tween = get_tree().create_tween().set_parallel()
					tween.tween_property(SceneChangeLightGreyOverlay, "position", Vector2(0.0, 0.0), animationTime).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
					tween.tween_property(SceneChangeDarkGreyOverlay, "position", Vector2(0.0, -9.0), animationTime).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(0.3)

				elif animationOrigin == "BOTTOM":
					
					SceneChangeDarkGreyOverlay.position = Vector2(0, 1500)
					SceneChangeLightGreyOverlay.position = Vector2(0, 1500)
					
					print("[TransitionManager] Animating from player node from origin: BOTTOM")
					
					## animateColorRect_IN(SceneChangeLightGreyOverlay, 0.0, 0.0, animationTime, "EXPO")
					## animateColorRect_IN(SceneChangeDarkGreyOverlay, 0.0, -9.0, animationTime, "EXPO")
					
					var tween = get_tree().create_tween().set_parallel()
					tween.tween_property(SceneChangeLightGreyOverlay, "position", Vector2(0.0, 0.0), animationTime).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
					tween.tween_property(SceneChangeDarkGreyOverlay, "position", Vector2(0.0, -9.0), animationTime).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(0.3)

					
				else:
					printerr('[TransitionManager] Error getting animationOrigin, please use only "TOP" or "BOTTOM" for the parameter.')

		else:
			pass
			# create ColorRect from path logic
	else:
		printerr("[TransitionManager] Failed loading scene: " + str(sceneToChangeTo))
