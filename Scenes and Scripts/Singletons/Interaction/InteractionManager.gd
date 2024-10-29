extends Node

var notification_spawned = false
var is_colliding = false


func spawn_interaction_notification(_KEY:String, _MESSAGE:String):
	if notification_spawned == false:
		var INTERACTION_LAYER = get_node("/root/World/Player/Head/Camera3D/InteractionLayer")
		var NOTIFICATION = load("res://Scenes and Scripts/Scenes/Player/Interaction/InteractionHUD.tscn")
		var NOTIFICATION_INSTANCE = NOTIFICATION.instantiate()
		INTERACTION_LAYER.add_child(NOTIFICATION_INSTANCE)
		NOTIFICATION_INSTANCE.position = Vector2(-228 ,0)
		notification_spawned = true
