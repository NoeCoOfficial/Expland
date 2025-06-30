extends ColorRect

@export_node_path("Node3D") var sun_path

var sun : Node3D
var camera : Camera3D

func _ready():
	if sun_path:
		sun = get_node(sun_path)

func _process(delta):
	camera = get_viewport().get_camera_3d()
	
	if not sun or not camera:
		return

	var sun_world_pos = sun.global_transform.origin
	var sun_screen_pos = camera.unproject_position(sun_world_pos)

	var screen_size = get_viewport().get_visible_rect().size
	var sun_screen_uv = sun_screen_pos / screen_size

	material.set_shader_parameter("SunScreenUV", sun_screen_uv)
