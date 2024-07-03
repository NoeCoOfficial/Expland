extends CharacterBody3D
class_name Player
# General Variables

@export_group("General")
@export var StartPOS := Vector3(0, 0, 0)
@export var ResetPOS := Vector3(0, 0, 0)

@export_category("Physics")

# Bob variables
@export_group("View Bobbing")
@export var BOB_FREQ := 3.0
@export var BOB_AMP = 0.08
@export_subgroup("Other")
@export var Wave_Length = 0.0

# Mouse Variables
@export_group("Mouse")
@export var SENSITIVITY = 0.001

# Physics Variables
@export_group("Physics")
var speed
@export var WALK_SPEED = 5.0
@export var SPRINT_SPEED = 6.5
@export var JUMP_VELOCITY = 4.5
@export var gravity = 12.0

# Body parts variables
@onready var head = $Head
@onready var camera = $Head/Camera3D





func _input(_event):
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("Reset"):
		self.position = ResetPOS

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(80))

func _process(_delta):
	$Head/Camera3D.fov = SettingsData.FOV

func _ready():
	SettingsData.LoadSettings()
	self.position = StartPOS
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("Sprint"):
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
	
	Wave_Length += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(Wave_Length)
	
	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	return pos

