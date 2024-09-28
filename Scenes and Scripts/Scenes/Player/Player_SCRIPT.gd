# ============================================================= #
# Player_SCRIPT.gd
# ============================================================= #
#                       COPYRIGHT NOTICE                        #
#                           Noe Co.                             #
#                   2024 - All Rights Reserved                  #
#                                                               #
#                         MIT License                           #
#                                                               #
# Permission is hereby granted, free of charge, to any          #
# person obtaining a copy of this software and associated       #
# documentation files (the "Software"), to deal in the          #
# Software without restriction, including without limitation    #
# the rights to use, copy, modify, merge, publish, distribute,  #
# sublicense, and/or sell copies of the Software, and to        #
# permit persons to whom the Software is furnished to do so,    #
# subject to the following conditions:                          #
#                                                               #
# 1. The above copyright notice and this permission notice      #
#    shall be included in all copies or substantial portions    #
#    of the Software.                                           #
#                                                               #
# 2. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF      #
#    ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED    #
#    TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A        #
#    PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL  #
#    THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,  #
#    DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF        #
#    CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN    #
#    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER           #
#    DEALINGS IN THE SOFTWARE.                                  #
#                                                               #
#                   For inquiries, contact:                     #
#                  noeco.official@gmail.com                     #
# ============================================================= #

@icon("res://Textures/Icons/Script Icons/32x32/character_edit.png") # Give the node an icon (so it looks cool)

extends CharacterBody3D # Inheritance

# Utility variables
@export_group("Utility") ## A group for gameplay variables
@export var inventory_opened_in_air := false ## Checks if the inventory UI is opened in the air (so the same velocity can be kept, used in _physics_process()
@export var speed:float ## The speed of the player. Used in _physics_process, this variable changes to SPRINT_SPEED, CROUCH_SPEED or WALK_SPEED depending on what input is pressed.
@export var GAME_STATE := "NORMAL" ## The local game state. (Global variable is in PlayerData.gd and saved to a file)

"""

Below are the player scene's export variables. These are useful for flexibility between maps/levels.
The keyword @export means that they can be accessed in the inspector panel (right side)

"""

@export_group("Gameplay") ## A group for gameplay variables

@export_subgroup("Health") ## Health varibales subgroup
@export var UseHealth := true ## Checks if health should be used. If false no health label/bar will be displayed and the player won't be able to die/take damage)
@export var MaxHealth := 100 ## After death or when the game is first opened, the Health variable is set to this.
@export var Health := 100 ## The player's health.

@export_subgroup("Other") 
@export var Position := Vector3(0, 0, 0) ## What the live position for the player is. This no longer does anything if changed in the inspector panel.

@export_group("Spawn") ## A group for spawn variables

@export var StartPOS := Vector3(0, 0, 0) ## This no longer does anything if changed because this is always set to the value from the save file.
@export var ResetPOS := Vector3(0, 0, 0) ## Where the player goes if the Reset input is pressed. 999, 999, 999 for same as StartPOS.

@export_subgroup("Fade_In") ## A subgroup for the fade-in variables (on spawn)
@export var Fade_In := false ## Whether to use the fade-in or not.
@export var Fade_In_Time := 1.000 ## The time it takes for the overlay to reach Color(0, 0, 0, 0) (Invisible).

@export_group("Input") ## A group relating to inputs (keys on your keyboard)
@export var Reset := true ## Whether or not the player can use the Reset input to reset the player's position (will be off for final game.)
@export var Quit := true ## Whether or not the player can use the Quit input to quit the game (will be off for final game.)


@export_group("Visual") ## A group for visual/camera variables

@export_subgroup("Camera") ## Camera variables subgroup.
@export var FOV := 116 ## the Field Of Vision of the camera on the player. Set to 9999 to get the saved FOV value (settings.dat)

@export_subgroup("Crosshair") ## A subgroup for crosshair variables.
@export var crosshair_size = Vector2(12, 12) ## The size of the crosshair.

@export_group("View Bobbing") ## a group for view bobbing variables.


@export var BOB_FREQ := 3.0 ## The frequency of the waves (how often it occurs)
@export var BOB_AMP = 0.08 ## The amplitude of the waves (how much you actually go up and down)
@export var BOB_SMOOTHING_SPEED := 3.0  ## Speed to smooth the return to the original position. The lower it get's, the smoother it is.

@export_subgroup("Other") ## a subgroup for other view bobbing variables.
@export var Wave_Length = 0.0 ## The wavelength of the bobbing

@export_group("Mouse") ## A group for mouse variables.
@export var SENSITIVITY = 0.001 ## The sensitivity of the mouse when it is locked in the center (during gameplay)

@export_group("Physics") ## A group for physics variables.

@export_subgroup("Movement") ## A subgroup for movement variables.
@export var WALK_SPEED = 5.0 ## The normal speed at which the player moves.
@export var SPRINT_SPEED = 8.0 ## The speed of the player when the user is pressing/holding the Sprint input.
@export var JUMP_VELOCITY = 4.5 ## How much velocity the player has when jumping. The more this value is, the higher the player can jump.
@export_subgroup("Crouching") ## A subgroup for crouching variables.
@export var CROUCH_JUMP_VELOCITY = 4.5 ## How much velocity the player has when jumping. The more this value is, the higher the player can jump.
@export var CROUCH_SPEED := 5.0 ## The speed of the player when the user is pressing/holding the Crouch input.
@export var CROUCH_INTERPOLATION := 6.0 ## How long it takes to go to the crouching stance or return to normal stance.
@export_subgroup("Gravity") ## A subgroup for gravity variables.
@export var gravity = 12.0 ## Was originally 9.8 but I felt it to be too unrealistic. We all know what gravity is... right?


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

"""
Below are some utility functions. These are very useful when trying to preform actions that need to be custom made with code. 
"""
func format_number(n: int) -> String: # A function for formatting numbers easily. Must be an integer!
	if n >= 1_000:

		var i:float = snapped(float(n)/1_000, .01)
		return str(i).replace(",", ".") + "k"

	elif n >= 1_000_000:

		var i:float = snapped(float(n)/1_000_000, .01)
		return str(i).replace(",", ".") + "M"

	elif n >= 1_000_000_000:

		var i:float = snapped(float(n)/1_000_000_000, .01)
		return str(i).replace(",", ".") + "B"

	elif n >= 1_000_000_000_000:

		var i:float = snapped(float(n)/1_000_000_000_000, .01)
		return str(i).replace(",", ".") + "T"

	elif n >= 1_000_000_000_000_000:

		var i:float = snapped(float(n)/1_000_000_000_000_000, .01)
		return str(i).replace(",", ".") + "aa"

	else:

		# ran otherwise
		return str(n)

func _get_mouse_pos(): # get the position of the cursor.
	return get_viewport().get_mouse_position()

func center_mouse_cursor(): # center the mouse cursor (relative to the viewport size)
	var viewport = get_viewport()
	var viewport_size = viewport.get_visible_rect().size
	var center_position = viewport_size / 2
	viewport.warp_mouse(center_position)

func wait(seconds: float) -> void: # wait until the next line of code is executed. Similar to time.sleep() in python.
	await get_tree().create_timer(seconds).timeout

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

# Body parts variables. Used for reference when working with physics.
@onready var head = $Head # reference to the head of the player scene. (used for mouse movement and looking around)
@onready var camera = $Head/Camera3D # reference to the camera of the player (used for mouse movement and looking around)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
func _input(_event): # A built-in function that listens for input using the input map
	if Input.is_action_just_pressed("Quit") and Quit == true:
		if GAME_STATE == "NORMAL" or "INVENTORY":
			get_tree().quit()
	if Input.is_action_just_pressed("Reset") and Reset == true:
		if GAME_STATE == "NORMAL" or "INVENTORY":
			if ResetPOS == Vector3(999, 999, 999):
				self.position = StartPOS
				velocity.y = 0.0
			else:
				self.position = ResetPOS
				velocity.y = 0.0
		
	if Input.is_action_just_pressed("Inventory"):
		if GAME_STATE == "NORMAL":
			$Head/Camera3D/InventoryLayer.show()
			center_mouse_cursor()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			GAME_STATE = "INVENTORY"

			# Check if the player is in the air when inventory is opened
			inventory_opened_in_air = not is_on_floor()

		elif GAME_STATE == "INVENTORY":
			$Head/Camera3D/InventoryLayer.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			center_mouse_cursor()
			GAME_STATE = "NORMAL"
			inventory_opened_in_air = false  # Reset the flag when inventory is closed

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if GAME_STATE == "INVENTORY":
			head.rotate_y(-event.relative.x * SENSITIVITY/20)
			camera.rotate_x(-event.relative.y * SENSITIVITY/20)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		else:
			head.rotate_y(-event.relative.x * SENSITIVITY)
			camera.rotate_x(-event.relative.y * SENSITIVITY)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
func _physics_process(delta):
	
	# Crouching
	if GAME_STATE != "INVENTORY" and GAME_STATE != "DEAD" and is_on_floor():
		if Input.is_action_pressed("Crouch"):
			self.scale.y = lerp(self.scale.y, 0.5, CROUCH_INTERPOLATION * delta)
		else:
			self.scale.y = lerp(self.scale.y, 1.0, CROUCH_INTERPOLATION * delta)
	else:
		self.scale.y = lerp(self.scale.y, 1.0, CROUCH_INTERPOLATION * delta)
	
	
	if !GAME_STATE == "DEAD":
		# Always apply gravity regardless of the game state
		if not is_on_floor():
			velocity.y -= gravity * delta
		# Handle movement restrictions when the inventory is open
		if GAME_STATE == "INVENTORY":
			if is_on_floor():
				velocity.x = 0
				velocity.z = 0
				inventory_opened_in_air = false  # Reset the flag once player lands
			move_and_slide()  # Apply gravity and handle movement
			return

		# Jumping
		if Input.is_action_just_pressed("Jump") and is_on_floor() and !Input.is_action_pressed("Crouch"):
			velocity.y = JUMP_VELOCITY

		# Handle Speed
		if Input.is_action_pressed("Sprint") and !Input.is_action_pressed("Crouch"):
			speed = SPRINT_SPEED 
		elif Input.is_action_pressed("Crouch"):
			speed = CROUCH_SPEED
		else:
			speed = WALK_SPEED
		

		# Movement
		var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

		if is_on_floor():
			if direction != Vector3.ZERO:
				velocity.x = direction.x * speed
				velocity.z = direction.z * speed
			else:
				velocity.x = lerp(velocity.x, 0.0, delta * 10.0)
				velocity.z = lerp(velocity.z, 0.0, delta * 10.0)
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)

		move_and_slide()

		# Check if the player is moving and on the floor
		var is_moving = velocity.length() > 0.1 and is_on_floor()

		# Apply view bobbing only if the player is moving
		if is_moving:
			Wave_Length += delta * velocity.length()
			camera.transform.origin = _headbob(Wave_Length)
		else:
			# Smoothly return to original position when not moving
			var target_pos = Vector3(camera.transform.origin.x, 0, camera.transform.origin.z)
			camera.transform.origin = camera.transform.origin.lerp(target_pos, delta * BOB_SMOOTHING_SPEED)

# The headbob function remains the same
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	return pos
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


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

func _ready():
	NodeSetup()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # lock mouse

	PlayerSettingsData.LoadSettings() # Load settings from player settings data
	
	if PlayerData: # check if player data exists (it may not be initialized correctly)
		PlayerData.LoadData() # loads player data
	else:
		printerr("PlayerData autoload not found")
	
	Health = PlayerData.Health
	GAME_STATE = PlayerData.GAME_STATE

	if GAME_STATE == "DEAD":
		$Head/Camera3D/DeathScreen/BlackOverlay.set_self_modulate(Color(0, 0, 0, 1))
		$Head/Camera3D/OverlayLayer/Overlay.show()
		DeathScreen()

	if Fade_In == true:
		$Head/Camera3D/OverlayLayer/Overlay.show()
		var tween = get_tree().create_tween()
		tween.tween_property($Head/Camera3D/OverlayLayer/Overlay, "self_modulate", Color(0, 0, 0, 0), Fade_In_Time)
		tween.tween_property($Head/Camera3D/OverlayLayer/Overlay, "visible", false, 0)
	else:
		$Head/Camera3D/OverlayLayer/Overlay.hide()
	
func NodeSetup():
	$Head/Camera3D/DeathScreen/BlackOverlay/GetUp.set_self_modulate(Color(0, 0, 0, 0))
	$Head/Camera3D/DeathScreen/BlackOverlay/RandomText.set_self_modulate(Color(0, 0, 0, 0))
	$Head/Camera3D/DeathScreen/BlackOverlay.set_self_modulate(Color(0, 0, 0, 0))
	$Head/Camera3D/OverlayLayer/RedOverlay.set_self_modulate(Color(1, 0.016, 0, 0))

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

func TakeDamage(DamageToTake):
	if UseHealth == true:
		Health -= DamageToTake
		PlayerData.Health = Health
		if Health <= 0: # check if health = 0 or below
			
			$Head/Camera3D/InventoryLayer.hide() # hide inventory
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # lock mouse
			
			GAME_STATE = "DEAD"
			PlayerData.GAME_STATE = "DEAD"
			Health = 0
			PlayerData.Health = Health
			DeathScreen()
		else:
			TakeDamageOverlay()
func TakeDamageOverlay():
	var tween = get_tree().create_tween()
	tween.tween_property($Head/Camera3D/OverlayLayer/RedOverlay, "self_modulate", Color(1, 0.018, 0, 0.808), 0).from(Color(1, 0.016, 0, 0))
	tween.tween_property($Head/Camera3D/OverlayLayer/RedOverlay, "self_modulate", Color(1, 0.016, 0, 0), 0.5)
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
		"Your story ends here.",
		"Not even time can save you now.",
		"Everything you know has crumbled.",
		"The end is inevitable.",
		"No one will remember you.",
		"All your efforts were in vain.",
		"This world doesn't need you anymore.",
		"The void welcomes you.",
		"Was it worth it?",
		"Death is just the beginning.",
		"Your journey ends in silence.",
		"Only shadows remain.",
		"Hope fades into the darkness.",
		"Your struggle was meaningless.",
		"Nothing can undo what you've done.",
		"How could you let this happen?"
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
