extends CharacterBody3D

@onready var camera_3d = $Head/Camera3D

# bob variables
@export var BOB_FREQ := 3.0
@export var BOB_AMP = 0.08
@export var t_bob = 0.0


@export var SENSITIVITY = 0.001
var speed
@export var WALK_SPEED = 5.0
@export var SPRINT_SPEED = 6.5
@export var JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 12

@onready var head = $Head
@onready var camera = $Head/Camera3D


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(80))

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Settings.global_settings.on_camera_fov_updated.connect(update_camera_fov)
	update_camera_fov(Settings.global_settings.get_camera_fov())

func update_camera_fov(fov: int) -> void:
	camera_3d.fov = fov

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 10.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 10.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	return pos

