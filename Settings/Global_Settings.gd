extends Resource

class_name GlobalSettings
signal on_camera_fov_updated(fov: int)

@export var camera_fov: int = 75 : set = set_camera_fov, get = get_camera_fov


func set_camera_fov(value: int) -> void:
	camera_fov = value
	on_camera_fov_updated.emit(camera_fov)

func get_camera_fov() -> int:
	return camera_fov
