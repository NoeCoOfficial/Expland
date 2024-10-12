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
@export var Health := 100 ## The player's health. If this reaches 0, the player dies.

@export_subgroup("Other") 
@export var Position := Vector3(0, 0, 0) ## What the live position for the player is. This no longer does anything if changed in the inspector panel.

@export_group("Spawn") ## A group for spawn variables

@export var StartPOS := Vector3(0, 0, 0) ## This no longer does anything if changed because this is always set to the value from the save file.
@export var ResetPOS := Vector3(0, 0, 0) ## Where the player goes if the Reset input is pressed. 999, 999, 999 for same as StartPOS. 

@export_subgroup("Fade_In") ## A subgroup for the fade-in variables (on spawn)
@export var Fade_In := false ## Whether to use the fade-in on startup or not. Reccomended to keep this on because it looks cool. 
@export var Fade_In_Time := 1.000 ## The time it takes for the overlay to reach Color(0, 0, 0, 0) in seconds. 

@export_group("Input") ## A group relating to inputs (keys on your keyboard)
@export var Reset := true ## Whether or not the player can use the Reset input to reset the player's position (Normally Ctrl+R) (will be off for final game.)
@export var Quit := true ## Whether or not the player can use the Quit input to quit the game (Normally Ctrl+Shift+Q) (will be off for final game.)


@export_group("Visual") ## A group for visual/camera variables

@export_subgroup("Camera") ## Camera variables subgroup.
@export var FOV := 116 ## the Field Of Vision of the camera on the player. Set to 9999 to get the saved FOV value (Saved to the path in PlayerSettingsData.gd) when the game starts.

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
@export var gravity = 12.0 ## Was originally 9.8 (Earth's gravitational pull) but I felt it to be too unrealistic. This is the gravity of the player. The higher this value is, the faster the player falls.

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

"""
Below are some utility functions. These are very useful when trying to preform actions that need to be custom made with code. 
"""
func format_number(n: int) -> String: # A function for formatting numbers easily. Must be an integer!
	if n >= 1_000: # if the number is greater than or equal to 1,000

		var i:float = snapped(float(n)/1_000, .01) # snap the number to the nearest 0.01
		return str(i).replace(",", ".") + "k" # return the number as a string with a "k" at the end

	elif n >= 1_000_000: # if the number is greater than or equal to 1,000,000

		var i:float = snapped(float(n)/1_000_000, .01) # snap the number to the nearest 0.01
		return str(i).replace(",", ".") + "M" # return the number as a string with a "M" at the end

	elif n >= 1_000_000_000: # if the number is greater than or equal to 1,000,000,000

		var i:float = snapped(float(n)/1_000_000_000, .01) # snap the number to the nearest 0.01
		return str(i).replace(",", ".") + "B" # return the number as a string with a "B" at the end

	elif n >= 1_000_000_000_000: # if the number is greater than or equal to 1,000,000,000,000

		var i:float = snapped(float(n)/1_000_000_000_000, .01) # snap the number to the nearest 0.01
		return str(i).replace(",", ".") + "T" # return the number as a string with a "T" at the end

	elif n >= 1_000_000_000_000_000: # if the number is greater than or equal to 1,000,000,000,000,000

		var i:float = snapped(float(n)/1_000_000_000_000_000, .01) # snap the number to the nearest 0.01
		return str(i).replace(",", ".") + "aa" # return the number as a string with a "aa" at the end

	else: 

		return str(n) # return the number as a string if it doesn't meet any of the above conditions

func _get_mouse_pos(): # get the position of the cursor.
	return get_viewport().get_mouse_position() # return the position of the cursor

func center_mouse_cursor(): # center the mouse cursor (relative to the viewport size)
	var viewport = get_viewport() # get the viewport
	var viewport_size = viewport.get_visible_rect().size # get the size of the viewport
	var center_position = viewport_size / 2 # get the center position of the viewport
	viewport.warp_mouse(center_position) # warp the mouse to the center position

func wait(seconds: float) -> void: # wait until the next line of code is executed. Similar to time.sleep() in python.
	await get_tree().create_timer(seconds).timeout # wait until the timer is finished

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
	if Input.is_action_just_pressed("Quit") and Quit == true: # if the Quit input is pressed and the Quit variable is true
		if GAME_STATE == "NORMAL" or "INVENTORY": # if the game state is normal or inventory
			if !GAME_STATE == "DEAD":
				get_tree().quit() # quit the game
	if Input.is_action_just_pressed("Reset") and Reset == true: # if the Reset input is pressed and the Reset variable is true
		if GAME_STATE == "NORMAL" or "INVENTORY": # if the game state is normal or inventory
			if ResetPOS == Vector3(999, 999, 999): # if the Reset position is set to 999, 999, 999
				self.position = StartPOS # set the player's position to the Start position
				velocity.y = 0.0 # set the player's velocity to 0
			else:
				self.position = ResetPOS # set the player's position to the Reset position 
				velocity.y = 0.0 # set the player's velocity to 0 
	if Input.is_action_just_pressed("SaveGame"):
		SaveManager.SaveAllData()
	if Input.is_action_just_pressed("Inventory"): # if the Inventory input is pressed
		if GAME_STATE == "NORMAL": # Check if the game state is normal. If it is, open the inventory
			$Head/Camera3D/InventoryLayer.show() # show the inventory UI
			center_mouse_cursor() # center the mouse cursor
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # set the mouse mode to visible
			GAME_STATE = "INVENTORY" # set the game state to inventory (so the player can't move. This won't save to the file)

			# Check if the player is in the air when inventory is opened
			inventory_opened_in_air = not is_on_floor() # Set the flag when inventory is opened in the air

		elif GAME_STATE == "INVENTORY": # Check if the game state is inventory. If it is, close the inventory
			$Head/Camera3D/InventoryLayer.hide() # hide the inventory UI
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # lock the mouse cursor
			center_mouse_cursor() # center the mouse cursor
			GAME_STATE = "NORMAL" # set the game state to normal (so the player can move. This won't save to the file)
			inventory_opened_in_air = false  # Reset the flag when inventory is closed

func _unhandled_input(event): # A built-in function that listens for input
	if event is InputEventMouseMotion: # if the input is a mouse motion event
		if GAME_STATE == "INVENTORY": # Check if the game state is inventory
			head.rotate_y(-event.relative.x * SENSITIVITY/20) # rotate the head on the y-axis
			camera.rotate_x(-event.relative.y * SENSITIVITY/20) # rotate the camera on the x-axis
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90)) # clamp the camera rotation on the x-axis
		else:
			head.rotate_y(-event.relative.x * SENSITIVITY) # rotate the head on the y-axis
			camera.rotate_x(-event.relative.y * SENSITIVITY) # rotate the camera on the x-axis
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90)) # clamp the camera rotation on the x-axis
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
func _physics_process(delta): # This is a special function that is called every frame. It is used for physics calculations. For example, if I run the game on a computer that has a higher/lower frame rate, the physics will still be consistent.
	
	# Crouching
	if GAME_STATE != "INVENTORY" and GAME_STATE != "DEAD" and is_on_floor(): # Check if the game state is not inventory or dead and if the player is on the floor
		if Input.is_action_pressed("Crouch"): # Check if the Crouch input is pressed
			self.scale.y = lerp(self.scale.y, 0.5, CROUCH_INTERPOLATION * delta) # linearly interpolate the scale of the player on the y-axis to 0.5
		else: 
			self.scale.y = lerp(self.scale.y, 1.0, CROUCH_INTERPOLATION * delta) # linearly interpolate the scale of the player on the y-axis to 1.0
	else:
		self.scale.y = lerp(self.scale.y, 1.0, CROUCH_INTERPOLATION * delta) # linearly interpolate the scale of the player on the y-axis to 1.0
	
	
	if !GAME_STATE == "DEAD":
		# Always apply gravity regardless of the game state
		if not is_on_floor(): # Check if the player is not on the floor
			velocity.y -= gravity * delta # apply gravity to the player
		# Handle movement restrictions when the inventory is open
		if GAME_STATE == "INVENTORY": # Check if the game state is inventory
			if is_on_floor(): # Check if the player is on the floor
				velocity.x = 0 # Stop the player from moving
				velocity.z = 0 # Stop the player from moving
				inventory_opened_in_air = false  # Reset the flag once player lands
			move_and_slide()  # Apply gravity and handle movement
			return 

		# Jumping
		if Input.is_action_just_pressed("Jump") and is_on_floor() and !Input.is_action_pressed("Crouch"): # Check if the Jump input is pressed, the player is on the floor and the Crouch input is not pressed
			velocity.y = JUMP_VELOCITY # set the player's velocity to the jump velocity

		# Handle Speed
		if Input.is_action_pressed("Sprint") and !Input.is_action_pressed("Crouch"): # Check if the Sprint input is pressed and the Crouch input is not pressed
			speed = SPRINT_SPEED # set the speed to the sprint speed
		elif Input.is_action_pressed("Crouch"): # Check if the Crouch input is pressed
			speed = CROUCH_SPEED # set the speed to the crouch speed
		else: 
			speed = WALK_SPEED # set the speed to the walk speed
		

		# Movement
		var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward") # get the input direction
		var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized() # get the direction of the player

		if is_on_floor(): # Check if the player is on the floor
			if direction != Vector3.ZERO: # Check if the direction is not zero
				velocity.x = direction.x * speed # set the player's velocity on the x-axis to the direction times the speed
				velocity.z = direction.z * speed # set the player's velocity on the z-axis to the direction times the speed
			else:
				velocity.x = lerp(velocity.x, 0.0, delta * 10.0) # linearly interpolate the player's velocity on the x-axis to 0
				velocity.z = lerp(velocity.z, 0.0, delta * 10.0) # linearly interpolate the player's velocity on the z-axis to 0
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0) # linearly interpolate the player's velocity on the x-axis to the direction times the speed
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0) # linearly interpolate the player's velocity on the z-axis to the direction times the speed

		move_and_slide() # Apply gravity and handle movement

		# Check if the player is moving and on the floor
		var is_moving = velocity.length() > 0.1 and is_on_floor()

		# Apply view bobbing only if the player is moving
		if is_moving:
			Wave_Length += delta * velocity.length() # Increase the wave length based on the player's velocity
			camera.transform.origin = _headbob(Wave_Length) # Apply the headbob function to the camera's origin
		else:
			# Smoothly return to original position when not moving
			var target_pos = Vector3(camera.transform.origin.x, 0, camera.transform.origin.z) # get the target position
			camera.transform.origin = camera.transform.origin.lerp(target_pos, delta * BOB_SMOOTHING_SPEED) # linearly interpolate the camera's origin to the target position

# The headbob function remains the same
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO # set the position to zero
	pos.y = sin(time * BOB_FREQ) * BOB_AMP # set the y position to the sine of the time times the bob frequency times the bob amplitude
	return pos # return the position
func _process(_delta):

	if UseHealth == false: # Check if the UseHealth variable is false
		$Head/Camera3D/CrosshairCanvas/HealthLBL.hide() # hide the health label
	else: 
		$Head/Camera3D/CrosshairCanvas/HealthLBL.show() # show the health label
	
	$Head/Camera3D/CrosshairCanvas/HealthLBL.text = "Health: " + str(Health) # set the health label text to "Health: " + the health variable as a string	
	
	if FOV == 9999: # check if the FOV is set to 9999 (to get the saved FOV value)
		$Head/Camera3D.fov = PlayerSettingsData.FOV # set the camera's field of vision to the saved FOV value
	else:
		$Head/Camera3D.fov = FOV # set the camera's field of vision to the FOV value
	
	$Head/Camera3D/CrosshairCanvas/Crosshair.size = crosshair_size # set the crosshair size to the crosshair size variable


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

func _ready():
	NodeSetup() # Call the NodeSetup function to setup the nodes
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # lock mouse

	PlayerSettingsData.LoadSettings() # Load settings from player settings data
	
	if PlayerData: # check if player data exists (it may not be initialized correctly)
		PlayerData.LoadData() # loads player data
	else:
		printerr("PlayerData autoload not found") 
	
	Health = PlayerData.Health # set the health variable to the player data's health variable
	GAME_STATE = PlayerData.GAME_STATE # set the game state to the player data's game state

	if GAME_STATE == "DEAD": # check if the game state is dead
		$Head/Camera3D/DeathScreen/BlackOverlay.set_self_modulate(Color(0, 0, 0, 1)) # set the black overlay's self modulate to black
		$Head/Camera3D/OverlayLayer/Overlay.show() # show the overlay
		DeathScreen() # call the death screen function

	if Fade_In == true: # check if the fade in variable is true
		$Head/Camera3D/OverlayLayer/Overlay.show() # show the overlay
		var tween = get_tree().create_tween() # create a tween
		tween.tween_property($Head/Camera3D/OverlayLayer/Overlay, "self_modulate", Color(0, 0, 0, 0), Fade_In_Time) # tween the overlay's self modulate to black
		tween.tween_property($Head/Camera3D/OverlayLayer/Overlay, "visible", false, 0) # tween the overlay's visibility to false
	else:
		$Head/Camera3D/OverlayLayer/Overlay.hide() # hide the overlay
	
func NodeSetup(): # A function to setup the nodes. Called in the _ready function
	$Head/Camera3D/DeathScreen/BlackOverlay/GetUp.set_self_modulate(Color(0, 0, 0, 0)) # set the get up self modulate to black
	$Head/Camera3D/DeathScreen/BlackOverlay/RandomText.set_self_modulate(Color(0, 0, 0, 0)) # set the random text self modulate to black
	$Head/Camera3D/DeathScreen/BlackOverlay.set_self_modulate(Color(0, 0, 0, 0)) # set the black overlay self modulate to black
	$Head/Camera3D/OverlayLayer/RedOverlay.set_self_modulate(Color(1, 0.016, 0, 0)) # set the red overlay self modulate to red

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

func TakeDamage(DamageToTake): # A function to take damage from the player 
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
			DeathScreen() # call the death screen function 
		else:
			TakeDamageOverlay() # call the take damage overlay function
func TakeDamageOverlay(): # Overlay when taking damage 
	var tween = get_tree().create_tween() # create a tween
	tween.tween_property($Head/Camera3D/OverlayLayer/RedOverlay, "self_modulate", Color(1, 0.018, 0, 0.808), 0).from(Color(1, 0.016, 0, 0)) # tween the red overlay's self modulate to red
	tween.tween_property($Head/Camera3D/OverlayLayer/RedOverlay, "self_modulate", Color(1, 0.016, 0, 0), 0.5) # tween the red overlay's self modulate to red
func _on_respawn(): # A function to respawn the player after death
	GAME_STATE = "NORMAL" # set the game state to normal
	PlayerData.GAME_STATE = GAME_STATE # set the player data's game state to the game state
func RespawnFromDeath(): # A function to respawn the player from death
	self.position = StartPOS # set the player's position to the start position
	Health = MaxHealth # set the health to the max health
	PlayerData.Health = Health # set the player data's health to the health
	var tween = get_tree().create_tween() # create a tween
	tween.connect("finished", _on_respawn, 1) # connect the finished signal to the respawn function
	tween.tween_property($Head/Camera3D/DeathScreen/BlackOverlay, "self_modulate", Color(0, 0, 0, 0), 3) # tween the black overlay's self modulate to black
func _on_death_screen_finished(): # A function to call when the death screen is finished 
	RespawnFromDeath() # call the respawn from death function
func DeathScreen(): # A function to show the death screen 
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

######################################
func _on_spike_take_damage(DamageTaken): # A function to take damage from the spikes
	TakeDamage(DamageTaken) # call the take damage function
######################################

######################################
func _on_auto_save_timer_timeout(): # A function to save the player data every 0.3 seconds
	SaveManager.SaveAllData() # Saves everything

