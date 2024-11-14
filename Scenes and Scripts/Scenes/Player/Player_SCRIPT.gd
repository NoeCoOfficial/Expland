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

@icon("res://Textures/Icons/Script Icons/32x32/character.png") # Give the node an icon (so it looks cool)

extends CharacterBody3D # Inheritance

"""

Below are the player scene's export variables. These are useful for flexibility between maps/levels.
The keyword @export means that they can be accessed in the inspector panel (right side)

"""

######################################
# Utility group
######################################

@export_group("Utility") ## A group for gameplay variables

@export var inventory_opened_in_air := false ## Checks if the inventory UI is opened in the air (so the same velocity can be kept, used in _physics_process()
@export var speed:float ## The speed of the player. Used in _physics_process, this variable changes to SPRINT_SPEED, CROUCH_SPEED or WALK_SPEED depending on what input is pressed.
@export var GAME_STATE := "NORMAL" ## The local game state. (Global variable is in PlayerData.gd and saved to a file)

######################################
# Gameplay group
######################################

@export_group("Gameplay") ## A group for gameplay variables

@export_subgroup("Health") ## Health varibales subgroup 
@export var UseHealth := true ## Checks if health should be used. If false no health label/bar will be displayed and the player won't be able to die/take damage)
@export var MaxHealth := 100 ## After death or when the game is first opened, the Health variable is set to this. 
@export var Health := 100 ## The player's health. If this reaches 0, the player dies.

@export_subgroup("Other") 
@export var Position := Vector3(0, 0, 0) ## What the live position for the player is. This no longer does anything if changed in the inspector panel.

######################################
# Spawn group
######################################

@export_group("Spawn") ## A group for spawn variables

@export var StartPOS := Vector3(0, 0, 0) ## This no longer does anything if changed because this is always set to the value from the save file.
@export var ResetPOS := Vector3(0, 0, 0) ## Where the player goes if the Reset input is pressed. 999, 999, 999 for same as StartPOS. 

@export_subgroup("Fade_In") ## A subgroup for the fade-in variables (on spawn)
@export var Fade_In := false ## Whether to use the fade-in on startup or not. Reccomended to keep this on because it looks cool. 
@export var Fade_In_Time := 1.000 ## The time it takes for the overlay to reach Color(0, 0, 0, 0) in seconds. 

######################################
# Input group
######################################

@export_group("Input") ## A group relating to inputs (keys on your keyboard)

@export var Pause := true  ## Whether or not the player can use the Pause input to pause the game. (Normally Esc) (will be ON for final game.)
@export var Reset := true ## Whether or not the player can use the Reset input to reset the player's position (Normally Ctrl+R) (will be OFF for final game.)
@export var Quit := true ## Whether or not the player can use the Quit input to quit the game (Normally Ctrl+Shift+Q) (will be OFF for final game.)

######################################
# Input group
######################################

@export_group("Visual") ## A group for visual/camera variables

@export_subgroup("Crosshair") ## A subgroup for crosshair variables.
@export var crosshair_size = Vector2(5, 5) ## The size of the crosshair.

######################################
# View Bobbing group
######################################

@export_group("View Bobbing") ## a group for view bobbing variables.

@export var BOB_FREQ := 3.0 ## The frequency of the waves (how often it occurs)
@export var BOB_AMP = 0.08 ## The amplitude of the waves (how much you actually go up and down)
@export var BOB_SMOOTHING_SPEED := 3.0  ## Speed to smooth the return to the original position. The lower it get's, the smoother it is.

@export_subgroup("Other") ## a subgroup for other view bobbing variables.
@export var Wave_Length = 0.0 ## The wavelength of the bobbing

######################################
# Mouse group
######################################

@export_group("Mouse") ## A group for mouse variables.

@export var SENSITIVITY = 0.001 ## The sensitivity of the mouse when it is locked in the center (during gameplay)

######################################
# Physics group
######################################

@export_group("Physics") ## A group for physics variables.

@export_subgroup("Movement") ## A subgroup for movement variables.
@export var WALK_SPEED = 5.0 ## The normal speed at which the player moves.
@export var SPRINT_SPEED = 8.0 ## The speed of the player when the user is pressing/holding the Sprint input.
@export var JUMP_VELOCITY = 4.5 ## How much velocity the player has when jumping. The more this value is, the higher the player can jump.
var is_moving = false
var is_walking = false
var is_sprinting = false
var is_crouching = false

@export_subgroup("Crouching") ## A subgroup for crouching variables.
@export var CROUCH_JUMP_VELOCITY = 4.5 ## How much velocity the player has when jumping. The more this value is, the higher the player can jump.
@export var CROUCH_SPEED := 5.0 ## The speed of the player when the user is pressing/holding the Crouch input.
@export var CROUCH_INTERPOLATION := 6.0 ## How long it takes to go to the crouching stance or return to normal stance.

@export_subgroup("Gravity") ## A subgroup for gravity variables.
@export var gravity = 12.0 ## Was originally 9.8 (Earth's gravitational pull) but I felt it to be too unrealistic. This is the gravity of the player. The higher this value is, the faster the player falls.

######################################
# Node references
######################################

@onready var head = $Head # Reference to the head of the player scene. (used for mouse movement and looking around)
@onready var camera = $Head/Camera3D # Reference to the camera of the player (used for mouse movement and looking around)

######################################
# Input
######################################

func _input(_event): # A built-in function that listens for input using the input map
	if Input.is_action_just_pressed("Exit") and GAME_STATE == "INVENTORY":
		$Head/Camera3D/InventoryLayer.hide() # hide the inventory UI
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # lock the mouse cursor
		Utils.center_mouse_cursor() # center the mouse cursor
		GAME_STATE = "NORMAL" # set the game state to normal (so the player can move. This won't save to the file)
		inventory_opened_in_air = false  # Reset the flag when inventory is closed
	elif Input.is_action_just_pressed("Exit") and Pause == true and !PauseManager.is_inside_settings:
		if $Head/Camera3D/PauseLayer.is_visible() == true:
			resumeGame()
		else:
			pauseGame()
	elif Input.is_action_just_pressed("Exit") and PauseManager.is_inside_settings:
		$Head/Camera3D/SettingsLayer/SettingsUI.closeSettings()
	if Input.is_action_just_pressed("Quit") and Quit == true and OS.has_feature("debug"): # if the Quit input is pressed and the Quit variable is true
		if GAME_STATE == "NORMAL" or "INVENTORY": # if the game state is normal or inventory
			if !GAME_STATE == "DEAD":
				SaveManager.saveAllData()
				get_tree().quit() # quit the game
	if Input.is_action_just_pressed("Reset") and Reset == true and !PauseManager.is_paused and OS.has_feature("debug"):
		if GAME_STATE == "NORMAL" or "INVENTORY":
			if ResetPOS == Vector3(999, 999, 999):
				self.position = StartPOS # set the player's position to the Start position
				velocity.y = 0.0 # set the player's velocity to 0
			else:
				self.position = ResetPOS # set the player's position to the Reset position 
				velocity.y = 0.0 # set the player's velocity to 0 
	if Input.is_action_just_pressed("SaveGame"):
		saveAllDataWithAnimation()
	if Input.is_action_just_pressed("Inventory") and !PauseManager.is_paused: # if the Inventory input is pressed
		if GAME_STATE == "NORMAL": # Check if the game state is normal. If it is, open the inventory
			openInventory()
		elif GAME_STATE == "INVENTORY": # Check if the game state is inventory. If it is, close the inventory
			closeInventory()

func _unhandled_input(event): # A built-in function that listens for input
	if event is InputEventMouseMotion: # if the input is a mouse motion event
		if GAME_STATE == "INVENTORY" or PauseManager.is_paused: # Check if the game state is inventory
			head.rotate_y(-event.relative.x * SENSITIVITY/20) # rotate the head on the y-axis
			camera.rotate_x(-event.relative.y * SENSITIVITY/20) # rotate the camera on the x-axis
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90)) # clamp the camera rotation on the x-axis
		else:
			head.rotate_y(-event.relative.x * SENSITIVITY) # rotate the head on the y-axis
			camera.rotate_x(-event.relative.y * SENSITIVITY) # rotate the camera on the x-axis
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90)) # clamp the camera rotation on the x-axis

######################################
# Process functions
######################################

func _physics_process(delta):
	# Initialize movement state variables
	is_walking = false
	is_sprinting = false
	is_crouching = false
	
	# Crouching
	if GAME_STATE != "INVENTORY" and GAME_STATE != "DEAD" and is_on_floor() and !PauseManager.is_paused:
		if Input.is_action_pressed("Crouch"):
			self.scale.y = lerp(self.scale.y, 0.5, CROUCH_INTERPOLATION * delta)
		else:
			self.scale.y = lerp(self.scale.y, 1.0, CROUCH_INTERPOLATION * delta)
	else:
		self.scale.y = lerp(self.scale.y, 1.0, CROUCH_INTERPOLATION * delta)
	
	if GAME_STATE != "DEAD":
		# Always apply gravity unless game state is DEAD
		if not is_on_floor():
			velocity.y -= gravity * delta

		# Jumping
		if Input.is_action_just_pressed("Jump") and is_on_floor() and !Input.is_action_pressed("Crouch") and !PauseManager.is_paused and GAME_STATE != "INVENTORY":
			velocity.y = JUMP_VELOCITY

		# Handle Speed
		if Input.is_action_pressed("Sprint") and !Input.is_action_pressed("Crouch") and !PauseManager.is_paused and GAME_STATE != "INVENTORY":
			speed = SPRINT_SPEED
		elif Input.is_action_pressed("Crouch") and !PauseManager.is_paused and GAME_STATE != "INVENTORY":
			speed = CROUCH_SPEED
		else:
			speed = WALK_SPEED

		# Movement
		var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

		if is_on_floor():
			if direction != Vector3.ZERO and !PauseManager.is_paused and GAME_STATE != "INVENTORY":
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
		is_moving = velocity.length() > 0.1 and is_on_floor()

		# Update movement state variables based on the player's movement and state
		if is_moving:
			if Input.is_action_pressed("Sprint"):
				is_sprinting = true
			elif Input.is_action_pressed("Crouch"):
				is_crouching = true
			else:
				is_walking = true

		# Apply view bobbing only if the player is moving
		if is_moving:
			Wave_Length += delta * velocity.length()
			camera.transform.origin = _headbob(Wave_Length)
		else:
			# Smoothly return to original position when not moving
			var target_pos = Vector3(camera.transform.origin.x, 0, camera.transform.origin.z)
			camera.transform.origin = camera.transform.origin.lerp(target_pos, delta * BOB_SMOOTHING_SPEED)

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO # set the position to zero
	pos.y = sin(time * BOB_FREQ) * BOB_AMP # set the y position to the sine of the time times the bob frequency times the bob amplitude
	return pos # return the position

func _process(_delta):
	
	## DEBUGGING
	
	$Head/Camera3D.fov = PlayerSettingsData.FOV
	# Get the time
	var time_now = Time.get_time_dict_from_system()
	var hours = time_now["hour"]
	var minutes = time_now["minute"]
	var seconds = time_now["second"]
	var time_string = str(hours).pad_zeros(2) + ":" + str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
	
	
	$Head/Camera3D/DebugLayer/player_position.text = "Player position: " + str(self.position)
	$Head/Camera3D/DebugLayer/player_velocity_y.text = "velocity.y = " + str(round(velocity.y))
	$Head/Camera3D/DebugLayer/player_velocity_y_accurate.text = str(velocity.y)
	$Head/Camera3D/DebugLayer/current_time.text = time_string
	$Head/Camera3D/DebugLayer/is_on_floor.text = "is_on_floor() = " + str(is_on_floor())
	$Head/Camera3D/DebugLayer/item_ref_LBL.text = "item_ref = " + InventoryManager.item_ref
	$Head/Camera3D/DebugLayer/current_fps.text = "FPS: %d" % Engine.get_frames_per_second()
	$Head/Camera3D/DebugLayer/is_raycast_colliding.text = "RayCast colliding? " + str(InteractionManager.is_colliding)
	$Head/Camera3D/DebugLayer/showing_interaction_notification.text = "Showing notification? " + str(InteractionManager.is_notification_on_screen)
	$Head/Camera3D/DebugLayer/is_inside_settings.text = "is_inside_settings = " + str(PauseManager.is_inside_settings)
	$Head/Camera3D/DebugLayer/is_moving.text = "is_moving = " + str(is_moving)
	$Head/Camera3D/DebugLayer/is_walking.text = "is_walking = " + str(is_walking)
	$Head/Camera3D/DebugLayer/is_sprinting.text = "is_sprinting = " + str(is_sprinting)
	$Head/Camera3D/DebugLayer/is_crouching.text = "is_crouching = " + str(is_crouching)

	## END DEBUGGING
	
	# HUD
	if UseHealth == false: # Check if the UseHealth variable is false
		$Head/Camera3D/CrosshairCanvas/HealthLBL.hide() # hide the health label
	else: 
		$Head/Camera3D/CrosshairCanvas/HealthLBL.show() # show the health label
	
	$Head/Camera3D/CrosshairCanvas/HealthLBL.text = "Health: " + str(Health) # set the health label text to "Health: " + the health variable as a string	
	
	
	$Head/Camera3D/CrosshairCanvas/Crosshair.size = crosshair_size # set the crosshair size to the crosshair size variable

######################################
# On startup
######################################

func _ready():
	nodeSetup() # Call the nodeSetup function to setup the nodes
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Lock mouse
	
	Health = PlayerData.Health # set the health variable to the player data's health variable
	GAME_STATE = PlayerData.GAME_STATE # set the game state to the player data's game state

	if GAME_STATE == "DEAD": # check if the game state is dead
		$Head/Camera3D/DeathScreen/BlackOverlay.set_self_modulate(Color(0, 0, 0, 1)) # set the black overlay's self modulate to black
		$Head/Camera3D/OverlayLayer/Overlay.show() # show the overlay
		showDeathScreen() # call the death screen function

	if Fade_In == true: # check if the fade in variable is true
		$Head/Camera3D/OverlayLayer/Overlay.show() # show the overlay
		var tween = get_tree().create_tween() # create a tween
		tween.tween_property($Head/Camera3D/OverlayLayer/Overlay, "self_modulate", Color(0, 0, 0, 0), Fade_In_Time) # tween the overlay's self modulate to black
		tween.tween_property($Head/Camera3D/OverlayLayer/Overlay, "visible", false, 0) # tween the overlay's visibility to false
	else:
		$Head/Camera3D/OverlayLayer/Overlay.hide() # hide the overlay
		
	if !OS.has_feature("debug"):
		$Head/Camera3D/PauseLayer/StartDebugging_Btn.hide()

func _on_ready() -> void: # Called when the node is considered ready
	pass # Replace with function body.

func nodeSetup(): # A function to setup the nodes. Called in the _ready function
	
	$Head/Camera3D/DeathScreen/BlackOverlay/GetUp.set_self_modulate(Color(0, 0, 0, 0)) # set the get up self modulate to black
	$Head/Camera3D/DeathScreen/BlackOverlay/RandomText.set_self_modulate(Color(0, 0, 0, 0)) # set the random text self modulate to black
	$Head/Camera3D/DeathScreen/BlackOverlay.set_self_modulate(Color(0, 0, 0, 0)) # set the black overlay self modulate to black
	$Head/Camera3D/OverlayLayer/RedOverlay.set_self_modulate(Color(1, 0.016, 0, 0)) # set the red overlay self modulate to red

######################################
# Walking, sprinting and crouching sounds
######################################

func _on_walking_speed_sounds_timeout() -> void:
	if is_walking:
		print("Play walking sound")

func _on_sprinting_speed_sounds_timeout() -> void:
	if is_sprinting:
		print("Play sprinting sound")

func _on_crouching_speed_sounds_timeout() -> void:
	if is_crouching:
		print("Play crouching sound")

######################################
# Health and dying
######################################

func takeDamage(DamageToTake): # A function to take damage from the player 
	if UseHealth == true: # Check if the UseHealth variable is true
		Health -= DamageToTake # subtract the damage to take from the health variable
		PlayerData.Health = Health # set the player data's health to the health variable 
		if Health <= 0: # check if health = 0 or below
			
			$Head/Camera3D/InventoryLayer.hide() # hide inventory
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # lock mouse
			
			GAME_STATE = "DEAD" # set the game state to dead
			PlayerData.GAME_STATE = "DEAD" # set the player data's game state to dead
			Health = 0 # set the health to 0
			PlayerData.Health = Health # set the player data's health to 0
			showDeathScreen() # call the death screen function 
		else:
			takeDamageOverlay() # call the take damage overlay function

func takeDamageOverlay(): # Overlay when taking damage 
	var tween = get_tree().create_tween() # create a tween
	tween.tween_property($Head/Camera3D/OverlayLayer/RedOverlay, "self_modulate", Color(1, 0.018, 0, 0.808), 0).from(Color(1, 0.016, 0, 0)) # tween the red overlay's self modulate to red
	tween.tween_property($Head/Camera3D/OverlayLayer/RedOverlay, "self_modulate", Color(1, 0.016, 0, 0), 0.5) # tween the red overlay's self modulate to red

func _on_respawn(): # A function to respawn the player after death
	GAME_STATE = "NORMAL" # set the game state to normal
	PlayerData.GAME_STATE = GAME_STATE # set the player data's game state to the game state

func respawnFromDeath(): # A function to respawn the player from death
	self.position = StartPOS # set the player's position to the start position
	Health = MaxHealth # set the health to the max health
	PlayerData.Health = Health # set the player data's health to the health
	var tween = get_tree().create_tween() # create a tween
	tween.connect("finished", _on_respawn, 1) # connect the finished signal to the respawn function
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay, "self_modulate", Color(0, 0, 0, 0), 3) # tween the black overlay's self modulate to black

func _on_death_screen_finished(): # A function to call when the death screen is finished 
	respawnFromDeath() # call the respawn from death function

func showDeathScreen(): # A function to show the death screen 
	var randomtext = [ # a list of random text to display when the player dies
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
	var random_index = randi() % randomtext.size() # get a random index from the random text list
	$Head/Camera3D/DeathScreen/BlackOverlay/RandomText.text = randomtext[random_index] # set the random text to a random text from the list
	
	## Death screen animation is as follows:
	var tween = get_tree().create_tween() # create a tween
	tween.connect("finished", _on_death_screen_finished, 1) # connect the finished signal to the death screen finished function
	
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay, "self_modulate", Color(0, 0, 0, 1), 0.5) # tween the black overlay's self modulate to black
	
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/RandomText, "self_modulate", Color(0, 0, 0, 0), 0) # tween the random text's self modulate to black
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/GetUp, "self_modulate", Color(0, 0, 0, 0), 0) # tween the get up's self modulate to black
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/GetUp, "visible", true, 0) # tween the get up's visibility to true
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/RandomText, "visible", true, 0) # tween the random text's visibility to true
	
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/RandomText, "self_modulate", Color(0, 0, 0, 1), 3) # hold
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/RandomText, "self_modulate", Color(1, 1, 1, 1), 0.5) # tween the random text's self modulate to white
	
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/RandomText, "self_modulate", Color(1, 1, 1, 1), 3) # hold
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/RandomText, "self_modulate", Color(0, 0, 0, 1), 0.5) # tween the random text's self modulate to black
	
	
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/GetUp, "self_modulate", Color(0, 0, 0, 1), 3) # Fade to black
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/GetUp, "self_modulate", Color(1, 1, 1, 1), 0.5) # tween the get up's self modulate to white
	
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/GetUp, "self_modulate", Color(1, 1, 1, 1), 2.6) # Fade to white
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/GetUp, "self_modulate", Color(0, 0, 0, 1), 0.5) # tween the get up's self modulate to black
	
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/GetUp, "visible", false, 0) # tween the get up's visibility to false
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/RandomText, "visible", false, 0) # tween the random text's visibility to false
	
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay/RandomText, "visible", false, 2) # hold
	
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay, "color", Color(1, 1, 1, 1), 0) # tween the black overlay's color to white
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay, "self_modulate", Color(1, 1, 1, 1), 3) # tween the black overlay's self modulate to white

######################################
# Inventory
######################################

func closeInventory():
	$Head/Camera3D/InventoryLayer.hide() # hide the inventory UI
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # lock the mouse cursor
	Utils.center_mouse_cursor() # center the mouse cursor
	GAME_STATE = "NORMAL" # set the game state to normal (so the player can move. This won't save to the file)
	inventory_opened_in_air = false  # Reset the flag when inventory is closed

func openInventory():
	$Head/Camera3D/InventoryLayer.show() # show the inventory UI
	Utils.center_mouse_cursor() # center the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # set the mouse mode to visible
	GAME_STATE = "INVENTORY" # set the game state to inventory (so the player can't move. This won't save to the file)
	inventory_opened_in_air = not is_on_floor() # Set the flag when inventory is opened in the air

func _on_boundary_area_entered(area):
	if area.is_in_group("draggable"):
		InventoryManager.is_inside_boundary = true

func _on_boundary_area_exited(area):
	if area.is_in_group("draggable"):
		InventoryManager.is_inside_boundary = false

######################################
# Pausing
######################################

func pauseGame():
	$Head/Camera3D/PauseLayer.show()
	PauseManager.is_paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # set the mouse mode to visible

func resumeGame():
	$Head/Camera3D/PauseLayer.hide()
	PauseManager.is_paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # lock the mouse cursor

func _on_resume_btn_pressed():
	resumeGame()

func _on_settings_btn_pressed():
	
	openSettings()

######################################
# Settings
######################################

func openSettings():
	$Head/Camera3D/SettingsLayer.visible = true
	$Head/Camera3D/SettingsLayer/SettingsUI.openSettings()

func closeSettings():
	pass

######################################
# Saving
######################################

func _on_save_and_quit_btn_pressed():
	SaveManager.saveAllData()
	get_tree().quit()

func saveAllDataWithAnimation():
	if $ManualSaveCooldown.time_left == 0.0:
		$ManualSaveCooldown.wait_time = 5.0
		$ManualSaveCooldown.start()
		SaveManager.saveAllData() # Call the save all data function from SaveManager to write all data to save files.
		showLighterBG_SAVEOVERLAY()
		await get_tree().create_timer(0.2).timeout
		showDarkerBG_SAVEOVERLAY()
		await get_tree().create_timer(3.0).timeout
		hideDarkerBG_SAVEOVERLAY() 
		await get_tree().create_timer(0.2).timeout
		hideLighterBG_SAVEOVERLAY()

func _on_auto_save_timer_timeout(): # A function to save the player data every 60 seconds (or how long the timer goes for)
	SaveManager.saveAllData() # Saves everything

######################################
# Save overlay animation
######################################

func showLighterBG_SAVEOVERLAY():
	var tween = get_tree().create_tween()
	tween.tween_property($Head/Camera3D/SaveOverlay/LighterBG, "position:x", 850.0, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func showDarkerBG_SAVEOVERLAY():
	var tween = get_tree().create_tween()
	tween.tween_property($Head/Camera3D/SaveOverlay/DarkerBG, "position:x", 858.0, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func hideLighterBG_SAVEOVERLAY():
	var tween = get_tree().create_tween()
	tween.tween_property($Head/Camera3D/SaveOverlay/LighterBG, "position:x", 1700.0, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)

func hideDarkerBG_SAVEOVERLAY():
	var tween = get_tree().create_tween()
	tween.tween_property($Head/Camera3D/SaveOverlay/DarkerBG, "position:x", 1796.0, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)

######################################
# Debugging
######################################

func _on_spike_take_damage(DamageTaken): # A function to take damage from the spike
	takeDamage(DamageTaken) # call the take damage function

func _on_start_debugging_btn_pressed() -> void:
	if $Head/Camera3D/DebugLayer.is_visible():
		$Head/Camera3D/DebugLayer.hide()
		$Head/Camera3D/PauseLayer/StartDebugging_Btn.text = "START DEBUGGING"
	else:
		$Head/Camera3D/DebugLayer.show()
		$Head/Camera3D/PauseLayer/StartDebugging_Btn.text = "STOP DEBUGGING"

######################################
# Playground
######################################
