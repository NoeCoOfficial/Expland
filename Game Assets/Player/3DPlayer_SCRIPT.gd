@icon("res://Textures/Icons/Script Icons/32x32/character_edit.png") # Give the node an icon (so it looks cool)
extends CharacterBody3D # Inheritance


@export_group("Gameplay") # A group for gameplay variables

@export_subgroup("Health") # Health varibales subgroup
@export var UseHealth := true # Checks if health should be used. If false no health label/bar will be displayed and the player won't be able to die/take damage)
@export var MaxHealth := 100 # After death or when the game is first opened, the Health variable is set to this.
@export var Health := 100 # The player's health.

@export_subgroup("Other") 
@export var Position := Vector3(0, 0, 0) # What the live position for the player is. This no longer does anything if changed in the inspector panel.


@export_group("Spawn") # A group for spawn variables

@export var StartPOS := Vector3(0, 0, 0) # This no longer does anything if changed because this is always set to the value from the save file.
@export var ResetPOS := Vector3(0, 0, 0) # Where the player goes if the Reset input is pressed. 999, 999, 999 for same as StartPOS.

@export_subgroup("Fade_In") # A subgroup for the fade-in variables (on spawn)
@export var Fade_In := false # Whether to use the fade-in or not.
@export var Fade_In_Time := 1.000 # The time it takes for the overlay to reach Color(1, 1, 1, 0) (Invisible).

@export_group("Input") # A group relating to inputs (keys on your keyboard)
@export var Reset := true # Whether or not the player can use the Reset input to reset the player's position (will be off for final game.)
@export var Quit := true # Whether or not the player can use the Quit input to quit the game (will be off for final game.)


@export_group("Visual") # A group for visual/camera variables

@export_subgroup("Camera") # Camera variables subgroup.
@export var FOV := 116 # the Field Of Vision of the camera on the player. Set to 9999 to get the saved FOV value (settings.dat)

@export_subgroup("Crosshair") # A subgroup for crosshair variables.
@export var crosshair_size = Vector2(8, 8) # The size of the crosshair.

@export_group("View Bobbing") # a group for view bobbing variables.


@export var BOB_FREQ := 3.0 # The frequency of the waves (how often it occurs)
@export var BOB_AMP = 0.08 # The amplitude of the waves (how much you actually go up and down)

@export_subgroup("Other") # a subgroup for other view bobbing variables.
@export var Wave_Length = 0.0 # The wavelength of the bobbing

@export_group("Mouse") # a group for mouse variables.
@export var SENSITIVITY = 0.001 # The sensitivity of the mouse when it is locked in the center (during gameplay)

@export_group("Physics") # A group for physics variables.


var speed # determines whether the player is pressing shift or not and whether to use the sprint speed or normal speed (code in physics process)
@export var WALK_SPEED = 5.0 # The speed of the player when the user isn't pressing/holding the Sprint input.
@export var SPRINT_SPEED = 8.0 # The speed of the player when the user is pressing/holding the Sprint input.
@export var JUMP_VELOCITY = 4.5 # Basically how high you can jump.
@export var gravity = 12.0 # Was originally 9.8 but I felt it to be too unrealistic. We all know what gravity is... right?


# Body parts variables
@onready var head = $Head # reference to the head of the player scene. (used for mouse movement and looking around)
@onready var camera = $Head/Camera3D # reference to the camera of the player (used for mouse movement and looking around)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
func _input(_event): # A built-in function that listens for input using the input map
	if Input.is_action_just_pressed("Quit") and Quit == true:
		get_tree().quit()
	if Input.is_action_just_pressed("Reset") and Reset == true:
		if ResetPOS == Vector3(999, 999, 999):
			self.position = StartPOS
		else:
			self.position = ResetPOS

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
func _physics_process(delta):
	# Always apply gravity regardless of the game state
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Jumping
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Sprinting
	if Input.is_action_pressed("Sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	
	# Movement
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, float(direction.x) * speed, delta * 10.0)
			velocity.z = lerp(velocity.z, float(direction.z) * speed, delta * 10.0)
	else:
		velocity.x = lerp(velocity.x, float(direction.x) * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, float(direction.z) * speed, delta * 3.0)
	
	
	move_and_slide()
	# Check if the player is moving (i.e., not just stopped by a collision) and on the floor
	var is_moving = velocity.length() > 0.1 and is_on_floor()
	
	# Apply view bobbing only if the player is moving
	if is_moving:
		Wave_Length += delta * velocity.length()
		camera.transform.origin = _headbob(Wave_Length)
	else:
		camera.transform.origin.y = 0  # Reset bobbing when not moving

func _process(_delta):
	
	if FOV == 9999:
		$Head/Camera3D.fov = PlayerSettingsData.FOV
	else:
		$Head/Camera3D.fov = FOV
	
	$Head/Camera3D/CrosshairCanvas/Crosshair.size = crosshair_size
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	return pos

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # lock mouse
