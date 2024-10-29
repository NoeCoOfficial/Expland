extends StaticBody3D

@onready var mesh_instance = $MainObj/Outline  

func _ready():
	mesh_instance.visible = false

func on_raycast_hit():
	mesh_instance.visible = true

func on_raycast_exit():
	mesh_instance.visible = false
