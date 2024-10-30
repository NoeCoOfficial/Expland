extends Control


func HideNotification():
	HideContents_NOTIFICATION()

func ShowNotification(KEY : String, MESSAGE : String):
	ShowLighterBG_NOTIFICATION()
	await get_tree().create_timer(0.2).timeout
	ShowContents_NOTIFICATION(KEY, MESSAGE)


func ShowLighterBG_NOTIFICATION():
	var tween = get_tree().create_tween()
	tween.tween_property($LighterBG, "position:x", 228.0, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func ShowContents_NOTIFICATION(KEY : String, MESSAGE : String):
	var tween = get_tree().create_tween()
	$Contents/KEY.text = KEY
	$Contents/MESSAGE.text = MESSAGE
	tween.tween_property($Contents, "position:x", 228.0, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func HideLighterBG_NOTIFICATION():
	var tween = get_tree().create_tween()
	tween.tween_property($LighterBG, "position:x", -228.0, 0.8).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)

func HideContents_NOTIFICATION():
	var tween = get_tree().create_tween()
	tween.tween_property($Contents, "position:x", 0.0, 0.8).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
