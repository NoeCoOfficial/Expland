extends StaticBody3D

@onready var mesh_instance = $MainObj/Outline  

func _ready():
	mesh_instance.visible = false

func on_raycast_hit():
	InteractionManager.is_hovering_over_test_obj = true
	mesh_instance.visible = true

func on_raycast_exit():
	mesh_instance.visible = false
	InteractionManager.is_hovering_over_test_obj = false
