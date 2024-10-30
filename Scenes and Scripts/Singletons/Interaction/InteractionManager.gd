extends Node

var notification_spawned = false
var is_colliding = false

var NOTIFICATION
var notification_contents
var notification_lighterBG

func spawn_interaction_notification(KEY : String, MESSAGE : String):
	if notification_spawned == false:
		NOTIFICATION = get_node("/root/World/Player/Head/Camera3D/InteractionLayer/InteractionHUD")

		notification_lighterBG = get_node("/root/World/Player/Head/Camera3D/InteractionLayer/InteractionHUD/LighterBG")
		notification_contents = get_node("/root/World/Player/Head/Camera3D/InteractionLayer/InteractionHUD/Contents")
		
		var NOTIFICATION_KEY = get_node("/root/World/Player/Head/Camera3D/InteractionLayer/InteractionHUD/Contents/KEY")
		var NOTIFICATION_MESSAGE = get_node("/root/World/Player/Head/Camera3D/InteractionLayer/InteractionHUD/Contents/MESSAGE")

		NOTIFICATION_KEY.text = KEY
		NOTIFICATION_MESSAGE.text = MESSAGE

		notification_spawned = true
