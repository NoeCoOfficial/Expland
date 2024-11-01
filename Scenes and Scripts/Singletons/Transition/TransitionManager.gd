extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
func ChangeSceneWithAnimation(animationOrigin : String):
	var SceneChangeDarkGreyOverlay
	var SceneChangeLightGreyOverlay

	if animationOrigin == "TOP":
		var tween = get_tree().create_tween()
		tween.tween_property(
		SceneChangeLightGreyOverlay,
		"position",
		Vector2(0, 0),
		1.0) # Also set ease and trans type here

	elif animationOrigin == "BOTTOM":
		var tween = get_tree().create_tween()
	else:
		printerr('Error getting animationOrigin, please use only "TOP" or "BOTTOM".')
