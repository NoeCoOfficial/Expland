extends Control


var in_pause: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func _input(event):
	if event.is_action_pressed("Pause"):
		in_pause = !in_pause
		visible = !in_pause
		get_tree().set_pause(in_pause)
		if in_pause:
			show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
