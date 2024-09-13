@icon("res://Textures/Icons/Script Icons/32x32/world.png")
extends Node3D

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		$Player.position = Vector3(-24.5325679779053, 23.8683662414551, 43.0636215209961)
		PlayerData.SaveData()
		call_deferred("change_scene")

func change_scene():
	get_tree().change_scene_to_file("res://Scenes and Scripts/Scenes/Tests/WorldShowcase.tscn")
