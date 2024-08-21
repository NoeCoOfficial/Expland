@icon("res://Textures/Icons/Script Icons/32x32/character_edit.png")
extends CharacterBody3D


var GAME_STATE := "NORMAL"

@export_group("Gameplay")
@export_subgroup("Health")
@export var UseHealth := true
@export var MaxHealth := 100
@export var Health := 100
@export_subgroup("Other")
@export var Position := Vector3(0, 0, 0)
# Spawn variables
@export_group("Spawn")
@export var StartPOS := Vector3(0, 0, 0)
@export var ResetPOS := Vector3(0, 0, 0) # 999, 999, 999 for same as startpos

@export_subgroup("Fade_In")
@export var Fade_In := false
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
	if Input.is_action_just_pressed("Quit") and Quit == true && GAME_STATE == "NORMAL":
		get_tree().quit()
	if Input.is_action_just_pressed("Reset") and Reset == true && GAME_STATE == "NORMAL":
		if ResetPOS == Vector3(999, 999, 999):
			self.position = StartPOS
		else:
			self.position = ResetPOS
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
########################################

########################################
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() && GAME_STATE == "NORMAL":
		velocity.y -= gravity * delta
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor() && GAME_STATE == "NORMAL":
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("Sprint") && GAME_STATE == "NORMAL":
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor() && GAME_STATE == "NORMAL":
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 10.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 10.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	if GAME_STATE == "NORMAL":
		Wave_Length += delta * velocity.length() * float(is_on_floor())
		camera.transform.origin = _headbob(Wave_Length)
	
	if GAME_STATE == "NORMAL":
		move_and_slide()
func _process(_delta):
	
	
	if UseHealth == false:
		$Head/Camera3D/CrosshairCanvas/HealthLBL.hide()
	else:
		$Head/Camera3D/CrosshairCanvas/HealthLBL.show()
	
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

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # lock mouse

	PlayerSettingsData.LoadSettings()

	Health = PlayerData.Health
	GAME_STATE = PlayerData.GAME_STATE

	if GAME_STATE == "DEAD":
		$Head/Camera3D/DeathScreen/BlackOverlay.set_self_modulate(Color(0, 0, 0, 1))
		$Head/Camera3D/CrosshairCanvas/Overlay.show()
		DeathScreen()

	if Fade_In == true:
		$Head/Camera3D/CrosshairCanvas/Overlay.show()
		var tween = get_tree().create_tween()
		tween.tween_property($Head/Camera3D/CrosshairCanvas/Overlay, "self_modulate", Color(0, 0, 0, 0), Fade_In_Time)
		tween.tween_property($Head/Camera3D/CrosshairCanvas/Overlay, "visible", false, 0)
	else:
		$Head/Camera3D/CrosshairCanvas/Overlay.hide()
	# Ensure the player starts at the correct position
	self.position = StartPOS
	push_warning("Initial position: ", self.position)

	# Load player data again to ensure position is set correctly
	if PlayerData:
		PlayerData.LoadData()
	else:
		printerr("PlayerData autoload not found")

######################################
func TakeDamage(DamageToTake):
	if UseHealth == true:
		Health -= DamageToTake
		PlayerData.Health = Health
		if Health <= 0:
			GAME_STATE = "DEAD"
			PlayerData.GAME_STATE = "DEAD"
			Health = 0
			PlayerData.Health = Health
			DeathScreen()
		else:
			TakeDamageOverlay()
func TakeDamageOverlay():
	var tween = get_tree().create_tween()
	tween.tween_property($Head/Camera3D/CrosshairCanvas/RedOverlay, "self_modulate", Color(1, 0.018, 0, 0.808), 0).from(Color(1, 0.016, 0, 0))
	tween.tween_property($Head/Camera3D/CrosshairCanvas/RedOverlay, "self_modulate", Color(1, 0.016, 0, 0), 0.5)
func _on_respawn():
	GAME_STATE = "NORMAL"
	PlayerData.GAME_STATE = GAME_STATE
func RespawnFromDeath():
	self.position = StartPOS
	Health = MaxHealth
	PlayerData.Health = Health
	var tween = get_tree().create_tween()
	tween.connect("finished", _on_respawn, 1)
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay, "self_modulate", Color(0, 0, 0, 0), 3)	
func _on_death_screen_finished():
	RespawnFromDeath()
func DeathScreen():
	var randomtext = [
		"Pull yourself together.",
		"Why did you have to die?",
		"You will never get back now.",
		"Your soul has been sealed.",
		"You have now become one with the sky.",
		"What have you done?",
		"As you die, they will make more.",
		"The more you fight, the more you lose.",
		"Every fail you have the more they succeed.",
		"Even gods fall.",
		"There have been many cycles.",
		"Why am I even talking to you?",
		"Stop kidding yourself. This isn't a game.",
		"What did you do?",
		"You did everything to deserve this.",
		]
	randomize()  # Seed the random number generator
	var random_index = randi() % randomtext.size()
	$Head/Camera3D/DeathScreen/BlackOverlay/RandomText.text = randomtext[random_index]
	
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
	TakeDamage(DamageTaken)
######################################

######################################
func _on_auto_save_timer_timeout():
	PlayerData.SaveData()
	PlayerSettingsData.SaveSettings()
