extends CharacterBody3D



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 12.0


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	move_and_slide()
