extends Control




func ShowNotification(KEY : String, MESSAGE : String):
	ShowLighterBG_NOTIFICATION()

func ShowLighterBG_NOTIFICATION():
	var tween = get_tree().create_tween()
	tween.tween_property($LighterBG, "position:x", 200.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func ShowContents_NOTIFICATION(KEY : String, MESSAGE : String):
	var tween = get_tree().create_tween()
	$Contents/KEY.text = KEY
	$Contents/MESSAGE.text = MESSAGE
	tween.tween_property($Contents, "position", Vector2(0, 30), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func HideLighterBG_NOTIFICATION():
	var tween = get_tree().create_tween()
	tween.tween_property($LighterBG, "position:x", -228, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)

func HideContents_NOTIFICATION():
	var tween = get_tree().create_tween()
	tween.tween_property($Contents, "position:x", -228, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
