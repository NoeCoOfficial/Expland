extends RayCast3D

var previous_collider = null

func _physics_process(_delta: float) -> void:
	if is_colliding():
		InteractionManager.is_colliding = true
		var collider = get_collider()
		if collider and collider.has_method("on_raycast_hit"):
			InteractionManager.spawn_interaction_notification("T", "Test!")
			collider.on_raycast_hit()  # Calls the function on the hit body
		previous_collider = collider
	else:
		InteractionManager.is_colliding = false
		if previous_collider and previous_collider.has_method("on_raycast_exit"):
			previous_collider.on_raycast_exit()
		previous_collider = null
