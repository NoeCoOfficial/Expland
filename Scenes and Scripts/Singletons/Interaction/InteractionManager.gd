extends Node


var is_notification_on_screen = false
var is_colliding = false

func spawn_interaction_notification(KEY : String, MESSAGE : String):
	if is_notification_on_screen == false:
		var interaction_node = get_node("/root/World/Player/Head/Camera3D/InteractionLayer/InteractionHUD")
		if interaction_node.has_method("ShowNotification"):
			interaction_node.ShowNotification(KEY, MESSAGE)
		is_notification_on_screen = true
