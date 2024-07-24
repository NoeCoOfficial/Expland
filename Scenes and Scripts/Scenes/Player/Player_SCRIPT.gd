@icon("res://Textures/Icons/Script Icons/32x32/character_edit.png")
extends CharacterBody3D


@export_group("Gameplay")
@export var UseHealth := true
@export var MaxHealth := 100
@export var Health := 100
# Spawn variables
@export_group("Spawn")
@export var StartPOS := Vector3(0, 0, 0)
@export var ResetPOS := Vector3(0, 0, 0) # 999, 999, 999 for same as startpos

@export_subgroup("Fade_In")
@export var Fade_In := false
@export var Fade_In_Colour := Color(0, 0, 0, 1)
@export var Fade_In_Time := 1.000

@export_group("Input")
@export var Reset := true
@export var Quit := true

# Visual variables
@export_group("Visual")

# Camera variables
@export_subgroup("Camera")
@export var FOV := 116 # set to 9999 to get the player save value

# Crosshair variables
@export_subgroup("Crosshair")
@export var crosshair_size = Vector2(12, 12)

# View bobbing variables
@export_group("View Bobbing")
@export var BOB_FREQ := 3.0
@export var BOB_AMP = 0.08
# Other view bobbing variables
@export_subgroup("Other")
@export var Wave_Length = 0.0

# Mouse Variables
@export_group("Mouse")
@export var SENSITIVITY = 0.001

# Physics Variables
@export_group("Physics")
var speed
@export var WALK_SPEED = 5.0
@export var SPRINT_SPEED = 8.0
@export var JUMP_VELOCITY = 4.5
@export var gravity = 12.0


func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

# Body parts variables
@onready var head = $Head
@onready var camera = $Head/Camera3D
########################################
########################################
func _input(_event):
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
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(80))
########################################

########################################
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
func _process(_delta):
	
	$Head/Camera3D/CrosshairCanvas/HealthLBL.text = "Health: " + str(Health)
	# This has stuff like export var setting
	
	
	if FOV == 9999:
		$Head/Camera3D.fov = PlayerSettingsData.FOV
	else:
		$Head/Camera3D.fov = FOV
	
	$Head/Camera3D/CrosshairCanvas/Crosshair.size = crosshair_size
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	return pos
######################################
func _ready():
	$Head/Camera3D/DeathScreen/BlackOverlay/GetUp.set_self_modulate(Color(0, 0, 0, 0))
	$Head/Camera3D/DeathScreen/BlackOverlay/RandomText.set_self_modulate(Color(0, 0, 0, 0))
	$Head/Camera3D/DeathScreen/BlackOverlay.set_self_modulate(Color(0, 0, 0, 0))
	$Head/Camera3D/CrosshairCanvas/RedOverlay.set_self_modulate(Color(1, 0.016, 0, 0))
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # lock mouse
	
	
	PlayerSettingsData.LoadSettings()
	PlayerData.LoadData()
	
	if Fade_In == true:
		$Head/Camera3D/CrosshairCanvas/Overlay.show()
		var tween = get_tree().create_tween()
		tween.tween_property($Head/Camera3D/CrosshairCanvas/Overlay, "self_modulate", Color(0, 0, 0, 0), Fade_In_Time).from(Fade_In_Colour)
		tween.tween_property($Head/Camera3D/CrosshairCanvas/Overlay, "visible", false, 0)
	else:
		$Head/Camera3D/CrosshairCanvas/Overlay.hide()
	self.position = StartPOS
######################################
func TakeDamageOverlay():
	var tween = get_tree().create_tween()
	tween.tween_property($Head/Camera3D/CrosshairCanvas/RedOverlay, "self_modulate", Color(1, 0.018, 0, 0.808), 0).from(Color(1, 0.016, 0, 0))
	tween.tween_property($Head/Camera3D/CrosshairCanvas/RedOverlay, "self_modulate", Color(1, 0.016, 0, 0), 0.5)
func RespawnFromDeath():
	self.position = StartPOS
	Health = MaxHealth
	var tween = get_tree().create_tween()
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay, "self_modulate", Color(0, 0, 0, 0), 3)
func _on_death_screen_finished():
	RespawnFromDeath()
func DeathScreen():
	var tween = get_tree().create_tween()
	tween.connect("finished", _on_death_screen_finished, 1)
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay, "self_modulate", Color(0, 0, 0, 1), 0.5)
	
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/RandomText, "self_modulate", Color(0, 0, 0, 0), 0)
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/GetUp, "self_modulate", Color(0, 0, 0, 0), 0)
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/GetUp, "visible", true, 0)
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/RandomText, "visible", true, 0)
	
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/RandomText, "self_modulate", Color(0, 0, 0, 1), 3) # hold
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/RandomText, "self_modulate", Color(1, 1, 1, 1), 0.5)
	
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/RandomText, "self_modulate", Color(1, 1, 1, 1), 3) # hold
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/RandomText, "self_modulate", Color(0, 0, 0, 1), 0.5)
	
	
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/GetUp, "self_modulate", Color(0, 0, 0, 1), 3)
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/GetUp, "self_modulate", Color(1, 1, 1, 1), 0.5)
	
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/GetUp, "self_modulate", Color(1, 1, 1, 1), 2.6)
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/GetUp, "self_modulate", Color(0, 0, 0, 1), 0.5)
	
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/GetUp, "visible", false, 0)
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/RandomText, "visible", false, 0)
	
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/RandomText, "visible", false, 2) # hold
	
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay, "color", Color(1, 1, 1, 1), 0)
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay, "self_modulate", Color(1, 1, 1, 1), 3)
######################################

######################################
func _on_spike_take_damage(DamageTaken):
	Health -= DamageTaken
	if Health <= 0:
		Health = 0
		DeathScreen()
	else:
		TakeDamageOverlay()