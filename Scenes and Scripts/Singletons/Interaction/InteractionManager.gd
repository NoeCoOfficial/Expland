# ============================================================= #
# InteractionManager.gd [AUTOLOAD]
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


var is_notification_on_screen = false
var is_colliding = false

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
