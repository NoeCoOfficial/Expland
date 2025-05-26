extends CharacterBody3D
@export var NavAgent : NavigationAgent3D
@export var rotation_speed : float = 5.0  # How fast the enemy rotates to face target
var CURRENT_STATE : EnemyStates = EnemyStates.CHASING

enum EnemyStates {
	IDLE,
	CHASING
}

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("test_action"):
		var random_pos = Vector3(randf_range(-5.0, 5.0), 1.5, randf_range(-5.0, 5.0))
		NavAgent.set_target_position(random_pos)
	
	if Input.is_action_just_pressed("test_action_2"):
		var pos = Vector3(0.0, 1.5, 0.0)
		NavAgent.set_target_position(pos)
	
	if Input.is_action_just_pressed("make_idle"):
		CURRENT_STATE = EnemyStates.IDLE
	if Input.is_action_just_pressed("make_chasing"):
		CURRENT_STATE = EnemyStates.CHASING

func _physics_process(delta: float) -> void:
	var destination = NavAgent.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	
	# Apply gravity
	velocity.y -= delta * 9.8
	
	if CURRENT_STATE == EnemyStates.CHASING:
		# Move towards target
		velocity.x = direction.x * 5.0
		velocity.z = direction.z * 5.0
		
		# Face the movement direction (only if we're actually moving)
		if direction.length() > 0.1:
			# Calculate the target rotation (looking towards the direction)
			var target_rotation = atan2(direction.x, direction.z)
			
			# Smoothly rotate towards the target
			rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed * delta)
	
	move_and_slide()
