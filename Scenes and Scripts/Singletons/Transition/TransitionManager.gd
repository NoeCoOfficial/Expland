extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func ChangeSceneWithAnimation(scene, animationOrigin : String, animationTime : float, pathToDarkOverlay, pathToLightOverlay):

	if load(scene):
		if pathToDarkOverlay == null or pathToLightOverlay == null:

			if get_node("/root/World/Player/Head/Camera/TransitionLayer/DarkGreyOverlay") != null and get_node("/root/World/Player/Head/Camera/TransitionLayer/LightGreyOverlay") != null:
				
				print("[TransitionManager] Using player transition overlay.")

				var SceneChangeDarkGreyOverlay = get_node("/root/World/Player/Head/Camera/TransitionLayer/DarkGreyOverlay")
				var SceneChangeLightGreyOverlay = get_node("/root/World/Player/Head/Camera/TransitionLayer/LightGreyOverlay")
				
				SceneChangeDarkGreyOverlay.position = Vector2(0, 0) # Replace with proper pos
				SceneChangeLightGreyOverlay.position = Vector2(0, 0) # Replace with proper pos

				if animationOrigin == "TOP":

					print("[TransitionManager] Animating from player node from origin: TOP")


					animateColorRect(SceneChangeLightGreyOverlay, 0.0, 0.0, animationTime) # Replace with proper pos
					await get_tree().create_timer(0.3).timeout
					animateColorRect(SceneChangeDarkGreyOverlay, 0.0., 0.0, animationTime) # Replace with proper pos

				elif animationOrigin == "BOTTOM":

					print("[TransitionManager] Animating from player node from origin: BOTTOM")


					animateColorRect(SceneChangeDarkGreyOverlay, 0.0, 0.0, animationTime) # Replace with proper pos
					await get_tree().create_timer(0.3).timeout
					animateColorRect(SceneChangeLightGreyOverlay, 0.0, 0.0, animationTime) # Replace with proper pos

				else:
					printerr('[TransitionManager] Error getting animationOrigin, please use only "TOP" or "BOTTOM" for the parameter.')


		else:		
			# create ColorRect from path logic
	else:
		printerr("[TransitionManager] Failed loading scene: " + str(scene))





func animateColorRect(colorRectNode, x : float, y : float, animationTime : float):
	var tween = get_tree().create_tween()
	tween.tween_property(colorRectNode, "position", Vector2(x, y), animationTime)