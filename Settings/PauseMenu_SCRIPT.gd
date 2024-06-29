extends Control

@onready var fov_slider = $FOV_SLIDER
@onready var camera_fov_count = $CameraFOV_COUNT

var in_menu: bool = false


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		in_menu = !in_menu
		visible = in_menu
		get_tree().set_pause(in_menu)
		if in_menu:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func connect_fov_settings() -> void:
	fov_slider.value_changed.connect(Settings.global_settings.set_camera_fov)
	Settings.global_settings.on_camera_fov_updated.connect(update_fov_label)
	fov_slider.set_value_no_signal(Settings.global_settings.get_camera_fov())
	update_fov_label(Settings.global_settings.get_camera_fov())

func update_fov_label(fov: int) -> void:
	camera_fov_count.set_text(str(fov))
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	connect_fov_settings()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
