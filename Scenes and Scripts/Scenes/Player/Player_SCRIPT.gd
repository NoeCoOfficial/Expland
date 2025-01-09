# ============================================================= #
# Player_SCRIPT.gd
# ============================================================= #
#                       COPYRIGHT NOTICE                        #
#                           Noe Co.                             #
#            (2024 - Present) - All Rights Reserved             #
#                                                               #
#                     Noe Co. Game License                      #
#                                                               #
# Permission is hereby granted to any person to view, fork,     #
# and make personal modifications to this software (the         #
# "Software"), solely for private, non-commercial use.          #
#                                                               #
# Restrictions:                                                 #
# 1. You may NOT distribute, publish, or make publicly          #
#    available any part of the original or modified Software.   #
# 2. You may NOT share, host, or release modified versions,     #
#    including derivative works, in any public or commercial    #
#    form.                                                      #
# 3. You may NOT use the Software for commercial purposes       #
#    without prior written permission from Noe Co.              #
#                                                               #
# Ownership:                                                    #
# Noe Co. retains all rights, title, and interest in and to     #
# the Software and associated intellectual property. This       #
# license does not grant ownership of the Software.             #
#                                                               #
# Termination:                                                  #
# This license is effective as of your initial access and       #
# remains until terminated. Breach of any term results in       #
# automatic termination, requiring destruction of all copies.   #
#                                                               #
# Disclaimer of Warranty:                                       #
# THE SOFTWARE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY      #
# KIND. NOE CO. DISCLAIMS ALL WARRANTIES, WHETHER EXPRESS,      #
# IMPLIED, OR STATUTORY, INCLUDING WARRANTIES OF                #
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.          #
#                                                               #
# Limitation of Liability:                                      #
# NOE CO. SHALL NOT BE LIABLE FOR ANY DAMAGES ARISING FROM      #
# USE OR INABILITY TO USE THE SOFTWARE, INCLUDING INDIRECT,     #
# INCIDENTAL, OR CONSEQUENTIAL DAMAGES.                         #
#                                                               #
#                   For inquiries, contact:                     #
#                  noeco.official@gmail.com                     #
# ============================================================= #

@icon("res://Textures/Icons/Script Icons/32x32/character.png") # Give the node an icon (so it looks cool)
extends CharacterBody3D # Inheritance

"""

Below are the player scene's export variables. These are useful for flexibility between maps/levels and referencing nodes.
The keyword @export means that they can be accessed in the inspector panel

"""

######################################
######################################

@export_category("Properties")

######################################
# Utility
######################################

var inventory_opened_in_air := false ## Checks if the inventory UI is opened in the air (so the same velocity can be kept, used in _physics_process()
var speed : float ## The speed of the player. Used in _physics_process, this variable changes to SPRINT_SPEED, CROUCH_SPEED or WALK_SPEED depending on what input is pressed.
var transitioning_to_menu = false
var stamina_restoring_f0 = false
var inventoryHand_debounce_timer = 0.2

######################################
# Gameplay group
######################################

@export_group("Gameplay") ## A group for gameplay variables

@export_subgroup("Health") ## Health varibales subgroup 
@export var UseHealth := true ## Checks if health should be used. If false no health label/bar will be displayed and the player won't be able to die/take damage)
@export var MaxHealth := 100 ## After death or when the game is first opened, the Health variable is set to this. 

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
######################################

@export_category("Node references")

@export_group("Body parts")

@export var head : Node3D
@export var camera : Camera3D
@export var PickupAttractionPos : Node3D

@export_group("Inventory")

@export var Slot1_Inventory_Ref : StaticBody2D
@export var Slot2_Inventory_Ref : StaticBody2D
@export var Slot_3_Inventory_Ref : StaticBody2D
@export var Slot_4_Inventory_Ref : StaticBody2D
@export var Slot_5_Inventory_Ref : StaticBody2D
@export var Slot_6_Inventory_Ref : StaticBody2D
@export var Slot_7_Inventory_Ref : StaticBody2D
@export var Slot_8_Inventory_Ref : StaticBody2D
@export var Slot_9_Inventory_Ref : StaticBody2D
@export var ChestMainLayer : Control
@export var Pickaxe_Video : VideoStreamPlayer
@export var Axe_Video : VideoStreamPlayer
@export var Sword_Video : VideoStreamPlayer
@export var EquipAnimations_Player : AnimationPlayer
@export var HAND_ITEM_TYPE_Label : Label


@export_group("General Nodes")

@export_subgroup("CanvasLayers")
@export var HUDLayer : CanvasLayer
@export var InventoryLayer : CanvasLayer
@export var InventoryMainLayer : CanvasLayer
@export var PauseLayer : CanvasLayer
@export var DebugLayer : CanvasLayer

@export_subgroup("UI")
@export var SettingsUI : Control
@export var AchievementsUI : Control
@export var AlertLayer : Control
@export var CreditsLayer : Control
@export var MinimalAlert : Control
@export var TopLayerBlackOverlay : Control
@export var SleepLayerBlackOverlay : Control
@export var DayText_Label : Control
@export var ProtectiveLayer : Control

@export_subgroup("HUD")
@export var Health_Bar : ProgressBar
@export var Crosshair_Rect : TextureRect
@export var StaminaBar : ProgressBar

@export_subgroup("Camera")
@export var DialogueInterface : Control
@export var DeathScreen_BlackOverlay : Control
@export var OverlayLayer_Overlay : Control
@export var InventoryLayer_Boundary : Area2D
@export var InventoryLayer_BoundaryChest : Area2D
@export var InventoryLayer_GreyLayer : ColorRect
@export var ItemWorkshopLayer_MainLayer : Control
@export var ItemWorkshopLayer_GreyLayer : ColorRect
@export var SaveOverlay_LighterBG : ColorRect
@export var SaveOverlay_DarkerBG : ColorRect
@export var HUDLayer_HealthBar : ProgressBar
@export var HUDLayer_HungerBar : ProgressBar
@export var GetUp_Label : Label
@export var RandomText_Label : Label
@export var OverlayLayer_RedOverlay : ColorRect

@export_subgroup("Timers")
@export var ManualSaveCooldown : Timer
@export var HandItemDebounce : Timer

@export_group("Debug")

@export var Inventory_Item_Ref_Label : Label
@export var Is_Raycast_Colliding_Label : Label
@export var Is_Inside_Settings_Label : Label
@export var Is_Inventory_Open_Label : Label
@export var Is_Moving_Label : Label
@export var Is_Walking_Label : Label
@export var Is_Sprinting_Label : Label
@export var Is_Crouching_Label : Label
@export var Is_In_Dialogue_Interface_Label : Label
@export var Showing_Interaction_Notification_Label : Label
@export var Current_Time_Label : Label
@export var Current_FPS_Label : Label
@export var Player_Position_Label : Label
@export var Player_VelocityY_Label : Label
@export var Player_VelocityY_Accurate_Label : Label
@export var Is_On_Floor_Label : Label
@export var Inputs_Currently_Pressing_Label : Label
@export var DAY_STATE_Label : Label
@export var GAME_STATE_Label : Label
@export var CURRENT_DAY_Label : Label
@export var CURRENT_HOUR_Label : Label
@export var CURRENT_WEATHER_Label : Label

######################################
# Input
######################################

func _input(_event): # A built-in function that listens for input using the input map
	
	if Input.is_action_just_pressed("Exit"):
		
		if PauseManager.is_paused:
			
			if !PauseManager.is_inside_settings and !PauseManager.is_inside_achievements_ui and !PauseManager.is_inside_credits and !PauseManager.is_inside_alert and !PlayerData.GAME_STATE == "DEAD" and !PlayerData.GAME_STATE == "SLEEPING":
				resumeGame()
			
			if PauseManager.is_inside_settings:
				SettingsUI.closeSettings(0.5)
			
			if PauseManager.is_inside_achievements_ui:
				AchievementsUI.despawnAchievements(0.5)
			
			if PauseManager.is_inside_alert:
				AlertLayer.despawnAlert(0.5)
			
			if PauseManager.is_inside_credits:
				CreditsLayer.despawnCredits(0.5)
			
		else:
			
			if !DialogueManager.is_in_absolute_interface and !InventoryManager.inventory_open and !PauseManager.is_inside_alert and !InventoryManager.in_chest_interface and !PlayerData.GAME_STATE == "DEAD" and !PlayerData.GAME_STATE == "SLEEPING" and !PauseManager.inside_absolute_item_workshop:
				pauseGame()
			
			if InventoryManager.inventory_open and !InventoryManager.in_chest_interface:
				closeInventory()
			
			if InventoryManager.in_chest_interface:
				if !InventoryManager.chestNode.is_animating():
					closeChest()
			
			if PauseManager.inside_item_workshop:
				closeItemWorkshop()
	
	if Input.is_action_just_pressed("Quit") and Quit == true and OS.has_feature("debug"): # if the Quit input is pressed and the Quit variable is true
		SaveManager.saveAllData()
		get_tree().quit() # quit the game
	
	if Input.is_action_just_pressed("Reset") and !PauseManager.inside_absolute_item_workshop and Reset == true and !PauseManager.is_paused and !PauseManager.is_inside_alert and OS.has_feature("debug"):
		if PlayerData.GAME_STATE == "NORMAL" or InventoryManager.inventory_open:
			if ResetPOS == Vector3(999, 999, 999):
				self.position = StartPOS # set the player's position to the Start position
				velocity.y = 0.0 # set the player's velocity to 0
			else:
				self.position = ResetPOS # set the player's position to the Reset position 
				velocity.y = 0.0 # set the player's velocity to 0 
	
	if Input.is_action_just_pressed("SaveGame") and OS.has_feature("debug") and IslandManager.Current_Game_Mode == "FREE":
		Utils.take_screenshot_in_thread("user://saveData/Free Mode/Islands/" + IslandManager.Current_Island_Name + "/island.png")
		
		saveAllDataWithAnimation()
	
	if Input.is_action_just_pressed("Inventory") and !PauseManager.inside_absolute_item_workshop and !PauseManager.is_paused and !InventoryManager.in_chest_interface and !PauseManager.is_inside_alert and !DialogueManager.is_in_absolute_interface and !PlayerData.GAME_STATE == "DEAD" and !PlayerData.GAME_STATE == "SLEEPING":
		if !InventoryManager.inventory_open:
			openInventory()
		else:
			closeInventory()
	
	if Input.is_action_just_pressed("RightClick") and inventoryHand_debounce_timer <= 0:
		if InventoryManager.is_hovering_over_hand_dropable:
			if InventoryManager.inventory_open and !InventoryManager.is_creating_pickup:
				if !InventoryData.HAND_ITEM_TYPE == "":
					var slots = [
						Slot1_Inventory_Ref,
						Slot2_Inventory_Ref,
						Slot_3_Inventory_Ref,
						Slot_4_Inventory_Ref,
						Slot_5_Inventory_Ref,
						Slot_6_Inventory_Ref,
						Slot_7_Inventory_Ref,
						Slot_8_Inventory_Ref,
						Slot_9_Inventory_Ref,
					]
					
					var free_slot = null
					
					# Get the free slot
					for i in range(slots.size()):
						if not slots[i].is_populated():
							free_slot = slots[i]
							break
					
					if free_slot != null and !free_slot.is_populated():
						
						InventoryManager.spawn_inventory_dropable(free_slot.position, InventoryData.HAND_ITEM_TYPE, free_slot)
						free_slot.set_populated(true)
						set_hand_item_type("")
						MinimalAlert.hide_minimal_alert(0.1)

func _unhandled_input(event): # A built-in function that listens for input all the time
	if event is InputEventMouseMotion: # if the input is a mouse motion event
		if InventoryManager.inventory_open or PauseManager.is_paused or PauseManager.is_inside_alert or DialogueManager.is_in_interface or InventoryManager.in_chest_interface or PauseManager.inside_can_move_item_workshop: # Check if the game state is inventory, or paused, or viewing dialogue.
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
	
	## Player movement and physics
	
	# Crouching
	if !InventoryManager.inventory_open and PlayerData.GAME_STATE != "DEAD" and PlayerData.GAME_STATE != "SLEEPING" and is_on_floor() and !InventoryManager.in_chest_interface and !PauseManager.is_paused and !PauseManager.is_inside_alert and !DialogueManager.is_in_absolute_interface and !PauseManager.inside_can_move_item_workshop:
		if Input.is_action_pressed("Crouch"):
			self.scale.y = lerp(self.scale.y, 0.5, CROUCH_INTERPOLATION * delta)
		else:
			self.scale.y = lerp(self.scale.y, 1.0, CROUCH_INTERPOLATION * delta)
	else:
		self.scale.y = lerp(self.scale.y, 1.0, CROUCH_INTERPOLATION * delta)
		
	if PlayerData.GAME_STATE != "DEAD":
		# Always apply gravity unless game state is DEAD
		if not is_on_floor():
			velocity.y -= gravity * delta
		
		# Jumping
		if Input.is_action_just_pressed("Jump") and !Input.is_action_pressed("Crouch") and is_on_floor() and !PauseManager.inside_can_move_item_workshop and !PauseManager.is_paused and !PauseManager.is_inside_alert and PlayerData.GAME_STATE != "SLEEPING" and !InventoryManager.in_chest_interface and !InventoryManager.inventory_open and !DialogueManager.is_in_absolute_interface:
			velocity.y = JUMP_VELOCITY
		
		# Handle Speed
		if Input.is_action_pressed("Sprint"):
			if !Input.is_action_pressed("Crouch") and !PauseManager.inside_can_move_item_workshop and !PauseManager.is_paused and PlayerData.GAME_STATE != "SLEEPING" and !InventoryManager.inventory_open and !DialogueManager.is_in_absolute_interface and !InventoryManager.in_chest_interface:
				speed = SPRINT_SPEED
				is_sprinting = true
		elif Input.is_action_pressed("Crouch") and !PauseManager.inside_can_move_item_workshop and !PauseManager.is_paused and PlayerData.GAME_STATE != "SLEEPING" and !InventoryManager.inventory_open and !DialogueManager.is_in_absolute_interface and !InventoryManager.in_chest_interface:
			speed = CROUCH_SPEED
			is_crouching = true
		else:
			speed = WALK_SPEED
			is_walking = true
		
		# Movement
		var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		if is_on_floor():
			if direction != Vector3.ZERO and !PauseManager.inside_can_move_item_workshop and !PauseManager.is_paused and PlayerData.GAME_STATE != "SLEEPING" and !PauseManager.is_inside_alert and !InventoryManager.in_chest_interface and !InventoryManager.inventory_open and !DialogueManager.is_in_absolute_interface:
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

func _process(delta):
	if inventoryHand_debounce_timer > 0:
		inventoryHand_debounce_timer -= delta
	
	SENSITIVITY = PlayerSettingsData.Sensitivity
	camera.fov = PlayerSettingsData.FOV
	
	## DEBUGGING
	
	# Get the time
	var time_now = Time.get_time_dict_from_system()
	var hours = time_now["hour"]
	var minutes = time_now["minute"]
	var seconds = time_now["second"]
	var time_string = str(hours).pad_zeros(2) + ":" + str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
	
	Inventory_Item_Ref_Label.text = "item_ref = " + InventoryManager.item_ref
	Is_Raycast_Colliding_Label.text = "RayCast colliding? " + str(InteractionManager.is_colliding)
	Is_Inside_Settings_Label.text = "is_inside_settings = " + str(PauseManager.is_inside_settings)
	Is_Inventory_Open_Label.text = "inventory_open? " + str(InventoryManager.inventory_open)
	Is_Moving_Label.text = "is_moving = " + str(is_moving)
	Is_Walking_Label.text = "is_walking = " + str(is_walking)
	Is_Sprinting_Label.text = "is_sprinting = " + str(is_sprinting)
	Is_Crouching_Label.text = "is_crouching = " + str(is_crouching)
	Is_In_Dialogue_Interface_Label.text = "In dialogue interface? " + str(DialogueManager.is_in_interface)
	Showing_Interaction_Notification_Label.text = "Showing notification? " + str(InteractionManager.is_notification_on_screen)
	Current_Time_Label.text = time_string
	Current_FPS_Label.text = "FPS: %d" % Engine.get_frames_per_second()
	Player_Position_Label.text = "Player position: " + str(self.position)
	Player_VelocityY_Label.text = "velocity.y = " + str(round(velocity.y))
	Player_VelocityY_Accurate_Label.text = str(velocity.y)
	Is_On_Floor_Label.text = "is_on_floor() = " + str(is_on_floor())
	DAY_STATE_Label.text = "DAY_STATE = " + TimeManager.DAY_STATE
	GAME_STATE_Label.text = "GAME_STATE = " + PlayerData.GAME_STATE
	CURRENT_DAY_Label.text = "CURRENT_DAY = " + str(TimeManager.CURRENT_DAY)
	CURRENT_HOUR_Label.text = "CURRENT_HOUR = " + str(TimeManager.CURRENT_HOUR)
	
	CURRENT_WEATHER_Label.text = "CURRENT_WEATHER = " + IslandManager.Current_Weather
	
	## END DEBUGGING
	
	# HUD
	if UseHealth == false: # Check if the UseHealth variable is false
		Health_Bar.hide()
	else: 
		Health_Bar.show()
	
	
	# TODO: Change when making crosshair setting
	Crosshair_Rect.size = crosshair_size # set the crosshair size to the crosshair size variable

######################################
# On startup
######################################

func _ready():
	nodeSetup() # Call the nodeSetup function to setup the nodes
	
	DialogueManager.DialogueInterface = DialogueInterface
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Lock mouse
	
	if PlayerData.GAME_STATE == "DEAD": # check if the game state is dead
		DeathScreen_BlackOverlay.set_self_modulate(Color(0, 0, 0, 1)) # set the black overlay's self modulate to black
		OverlayLayer_Overlay.show() # show the overlay
		showDeathScreen() # call the death screen function
	
	if Fade_In == true: # check if the fade in variable is true
		
		OverlayLayer_Overlay.show() # show the overlay
		
		var tween = get_tree().create_tween()
		tween.connect("finished", Callable(self, "on_fade_in_tween_finished"))
		tween.tween_interval(1.5)
		tween.tween_property(OverlayLayer_Overlay, "self_modulate", Color(0, 0, 0, 0), Fade_In_Time) # tween the overlay's self modulate to black
		tween.tween_property(OverlayLayer_Overlay, "visible", false, 0) # tween the overlay's visibility to false
		
	else:
		
		OverlayLayer_Overlay.hide() # hide the overlay
		
	if !OS.has_feature("debug"):
		PauseLayer.hide()

func on_fade_in_tween_finished():
	if IslandManager.Current_Game_Mode == "FREE":
		Utils.take_screenshot_in_thread("user://saveData/Free Mode/Islands/" + IslandManager.Current_Island_Name + "/island.png")

func _on_ready() -> void: # Called when the node is considered ready
	pass

func nodeSetup(): # A function to setup the nodes. Called in the _ready function
	HUDLayer_HealthBar.value = PlayerData.Health
	
	InventoryLayer.hide()
	InventoryMainLayer.hide()
	
	GetUp_Label.self_modulate = Color(0, 0, 0, 0) # set the get up self modulate to black
	RandomText_Label.self_modulate = Color(0, 0, 0, 0) # set the random text self modulate to black
	DeathScreen_BlackOverlay.self_modulate = Color(0, 0, 0, 0) # set the black overlay self modulate to black
	OverlayLayer_RedOverlay.self_modulate = Color(1, 0.016, 0, 0) # set the red overlay self modulate to red

######################################
# Walking, sprinting and crouching sounds
######################################

func _on_walking_speed_sounds_timeout() -> void:
	if is_walking:
		pass

func _on_sprinting_speed_sounds_timeout() -> void:
	if is_sprinting:
		pass

func _on_crouching_speed_sounds_timeout() -> void:
	if is_crouching:
		pass

######################################
# Health and dying
######################################

func takeDamage(DamageToTake): # A function to take damage from the player
	if UseHealth == true: # Check if the UseHealth variable is true
		PlayerData.Health -= DamageToTake # subtract the damage to take from the health variable
		
		if PlayerData.Health <= 0:
			update_bar("HEALTH", true, 0)
			
		else:
			update_bar("HEALTH", true, PlayerData.Health)
		
		if PlayerData.Health <= 0: # check if health = 0 or below
			
			resumeGame()
			closeInventory()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # lock mouse
			
			PlayerData.GAME_STATE = "DEAD" # set the player data's game state to dead
			PlayerData.Health = 0 # set the health to 0
			
			showDeathScreen() # call the death screen function 
			
			SaveManager.saveAllData()
			
		else:
			takeDamageOverlay() # call the take damage overlay function

func takeDamageOverlay(): # Overlay when taking damage 
	var tween = get_tree().create_tween() # create a tween
	tween.tween_property(OverlayLayer_RedOverlay, "self_modulate", Color(1, 0.018, 0, 0.808), 0).from(Color(1, 0.016, 0, 0)) # tween the red overlay's self modulate to red
	tween.tween_property(OverlayLayer_RedOverlay, "self_modulate", Color(1, 0.016, 0, 0), 0.5) # tween the red overlay's self modulate to red

func respawnFromDeath(): # A function to respawn the player from death
	self.position = StartPOS # set the player's position to the start position
	PlayerData.Health = MaxHealth # set the health to the max health
	
	var tween = get_tree().create_tween() # create a tween

	tween.tween_property(DeathScreen_BlackOverlay, "self_modulate", Color(0, 0, 0, 0), 3) # tween the black overlay's self modulate to black
	
	PlayerData.GAME_STATE = "NORMAL" # set the game state to normal

func _on_death_screen_finished(): # A function to call when the death screen is finished 
	respawnFromDeath() # call the respawn from death function

func showDeathScreen(): # A function to show the death screen 
	randomize()  # Seed the random number generator
	var random_index = randi() % DialogueManager.deathScreenRandomText.size() # get a random index from the random text list
	RandomText_Label.text = DialogueManager.deathScreenRandomText[random_index] # set the random text to a random text from the list
	
	## Death screen animation is as follows:
	var tween = get_tree().create_tween() # create a tween
	tween.connect("finished", _on_death_screen_finished, 1) # connect the finished signal to the death screen finished function
	
	tween.tween_property(DeathScreen_BlackOverlay, "self_modulate", Color(0, 0, 0, 1), 0.5) # tween the black overlay's self modulate to black
	
	tween.tween_property(RandomText_Label, "self_modulate", Color(0, 0, 0, 0), 0) # tween the random text's self modulate to black
	tween.tween_property(GetUp_Label, "self_modulate", Color(0, 0, 0, 0), 0) # tween the get up's self modulate to black
	tween.tween_property(GetUp_Label, "visible", true, 0) # tween the get up's visibility to true
	tween.tween_property(RandomText_Label, "visible", true, 0) # tween the random text's visibility to true
	
	tween.tween_property(RandomText_Label, "self_modulate", Color(0, 0, 0, 1), 3) # hold
	tween.tween_property(RandomText_Label, "self_modulate", Color(1, 1, 1, 1), 0.5) # tween the random text's self modulate to white
	
	tween.tween_property(RandomText_Label, "self_modulate", Color(1, 1, 1, 1), 3) # hold
	tween.tween_property(RandomText_Label, "self_modulate", Color(0, 0, 0, 1), 0.5) # tween the random text's self modulate to black
	
	
	tween.tween_property(GetUp_Label, "self_modulate", Color(0, 0, 0, 1), 3) # Fade to black
	tween.tween_property(GetUp_Label, "self_modulate", Color(1, 1, 1, 1), 0.5) # tween the get up's self modulate to white
	
	tween.tween_property(GetUp_Label, "self_modulate", Color(1, 1, 1, 1), 2.6) # Fade to white
	tween.tween_property(GetUp_Label, "self_modulate", Color(0, 0, 0, 1), 0.5) # tween the get up's self modulate to black
	
	tween.tween_property(GetUp_Label, "visible", false, 0) # tween the get up's visibility to false
	tween.tween_property(RandomText_Label, "visible", false, 0) # tween the random text's visibility to false
	
	tween.tween_property(RandomText_Label, "visible", false, 2) # hold
	
	tween.tween_property(DeathScreen_BlackOverlay, "color", Color(1, 1, 1, 1), 0) # tween the black overlay's color to white
	tween.tween_property(DeathScreen_BlackOverlay, "self_modulate", Color(1, 1, 1, 1), 3) # tween the black overlay's self modulate to white

######################################
# Inventory
######################################

func openInventory():
	if InventoryManager.in_chest_interface:
		
		InventoryLayer_Boundary.monitorable = false
		InventoryLayer_Boundary.monitoring = false
		
		InventoryLayer_BoundaryChest.monitorable = true
		InventoryLayer_BoundaryChest.monitoring = true
		
		InventoryMainLayer.offset.x = -291.96
		
	else:
		
		InventoryLayer_Boundary.monitorable = true
		InventoryLayer_Boundary.monitoring = true
		
		InventoryLayer_BoundaryChest.monitorable = false
		InventoryLayer_BoundaryChest.monitoring = false
		
		InventoryMainLayer.offset.x = 0
		ChestMainLayer.hide()
	
	InventoryMainLayer.show()
	InventoryLayer.show() # show the inventory UI
	Utils.center_mouse_cursor() # center the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # set the mouse mode to visible
	InventoryManager.inventory_open = true
	inventory_opened_in_air = not is_on_floor() # Set the flag when inventory is opened in the air
	
	set_hand_item_type(InventoryData.HAND_ITEM_TYPE)

func closeInventory():
	InventoryLayer_GreyLayer.show()
	saveInventory()
	InventoryMainLayer.hide()
	InventoryLayer.hide() # hide the inventory UI
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # lock the mouse cursor
	Utils.center_mouse_cursor() # center the mouse cursor
	InventoryManager.inventory_open = false
	inventory_opened_in_air = false  # Reset the flag when inventory is closed
	MinimalAlert.hide_minimal_alert(0.1)

func _on_boundary_area_entered(area):
	if area.is_in_group("draggable"):
		InventoryManager.is_inside_boundary = true

func _on_boundary_area_exited(area):
	if area.is_in_group("draggable"):
		InventoryManager.is_inside_boundary = false

func _on_pickup_object_detector_area_entered(area: Area3D) -> void:
	
	if area.is_in_group("pickup_player_detector"):
		
		var slots = [
			Slot1_Inventory_Ref,
			Slot2_Inventory_Ref,
			Slot_3_Inventory_Ref,
			Slot_4_Inventory_Ref,
			Slot_5_Inventory_Ref,
			Slot_6_Inventory_Ref,
			Slot_7_Inventory_Ref,
			Slot_8_Inventory_Ref,
			Slot_9_Inventory_Ref,
		]
		
		var free_slot = null
		
		# Get the free slot
		for i in range(slots.size()):
			if not slots[i].is_populated():
				free_slot = slots[i]
				break
		
		
		if free_slot != null and !free_slot.is_populated():
			
			free_slot.set_populated(true)
			
			area.set_deferred("monitorable", false)
			area.set_deferred("monitoring", false)
			
			print("{LOCAL} [Player_SCRIPT.gd] Free slot found: " + free_slot.name)
			
			var PickupObject = area.get_parent()
			var PickupItemType = PickupObject.get_ITEM_TYPE()
			var PlayerPos = PickupAttractionPos.global_position
			
			print("{LOCAL} [Player_SCRIPT.gd] Collided with pickup player detector! Item: " + PickupItemType)
			
			var tween1 = get_tree().create_tween().set_parallel()
			
			tween1.tween_property(PickupObject, "position", PlayerPos, 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
			tween1.tween_property(PickupObject, "scale", Vector3(0.00001, 0.00001, 0.00001), 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
			
			await get_tree().create_timer(0.1).timeout
			
			delete_pickup_object(PickupObject)
			InventoryManager.spawn_inventory_dropable(free_slot.position, PickupItemType, free_slot)
			
		else:
			print("{LOCAL} [Player_SCRIPT.gd] No free slot available.")

func delete_pickup_object(pickupobj):
	if pickupobj != null:
		pickupobj.queue_free()

func _on_hand_dropable_detector_mouse_entered() -> void:
	InventoryManager.is_hovering_over_hand_dropable = true
	if InventoryManager.inventory_open and InventoryData.HAND_ITEM_TYPE != "":
		MinimalAlert.show_minimal_alert(0.1, "Right click to put item back into pockets")

func _on_hand_dropable_detector_mouse_exited() -> void:
	InventoryManager.is_hovering_over_hand_dropable = false
	MinimalAlert.hide_minimal_alert(0.1)

func set_hand_item_type(ITEM_TYPE : String):
	inventoryHand_debounce_timer = 0.2
	if ITEM_TYPE == "":
		visually_equip("")
		InventoryData.HAND_ITEM_TYPE = ""
		HAND_ITEM_TYPE_Label.text = "Empty"
		Pickaxe_Video.visible = false
		Axe_Video.visible = false
		Sword_Video.visible = false
	
	elif ITEM_TYPE == "PICKAXE":
		visually_equip("PICKAXE")
		InventoryData.HAND_ITEM_TYPE = "PICKAXE"
		HAND_ITEM_TYPE_Label.text = "Pickaxe"
		Pickaxe_Video.visible = true
		Axe_Video.visible = false
		Sword_Video.visible = false
	
	elif ITEM_TYPE == "AXE":
		visually_equip("AXE")
		InventoryData.HAND_ITEM_TYPE = "AXE"
		HAND_ITEM_TYPE_Label.text = "Axe"
		Pickaxe_Video.visible = false
		Axe_Video.visible = true
		Sword_Video.visible = false
	
	elif ITEM_TYPE == "SWORD":
		visually_equip("SWORD")
		InventoryData.HAND_ITEM_TYPE = "SWORD"
		HAND_ITEM_TYPE_Label.text = "Sword"
		Pickaxe_Video.visible = false
		Axe_Video.visible = false
		Sword_Video.visible = true

func visually_equip(ITEM_TYPE):
	if !ITEM_TYPE == InventoryData.HAND_ITEM_TYPE:
		if ITEM_TYPE == "":
			if InventoryData.HAND_ITEM_TYPE != "":
				var anim_to_play : StringName = "unequip_" + InventoryData.HAND_ITEM_TYPE
				EquipAnimations_Player.play(anim_to_play)
		
		if ITEM_TYPE == "SWORD":
			if InventoryData.HAND_ITEM_TYPE == "":
				EquipAnimations_Player.play("equip_SWORD")
			else:
				var item_to_unequip : StringName = "unequip_" + InventoryData.HAND_ITEM_TYPE
				EquipAnimations_Player.play(item_to_unequip)
				await get_tree().create_timer(0.16).timeout
				EquipAnimations_Player.play("equip_SWORD")
		
		if ITEM_TYPE == "PICKAXE":
			if InventoryData.HAND_ITEM_TYPE == "":
				EquipAnimations_Player.play("equip_PICKAXE")
			else:
				var item_to_unequip : StringName = "unequip_" + InventoryData.HAND_ITEM_TYPE
				EquipAnimations_Player.play(item_to_unequip)
				await get_tree().create_timer(0.16).timeout
				EquipAnimations_Player.play("equip_PICKAXE")
		
		if ITEM_TYPE == "AXE":
			if InventoryData.HAND_ITEM_TYPE == "":
				EquipAnimations_Player.play("equip_AXE")
			else:
				var item_to_unequip : StringName = "unequip_" + InventoryData.HAND_ITEM_TYPE
				EquipAnimations_Player.play(item_to_unequip)
				await get_tree().create_timer(0.16).timeout
				EquipAnimations_Player.play("equip_AXE")

func init_visually_equip(ITEM_TYPE : String):
	
	if ITEM_TYPE == "":
		Pickaxe_Video.visible = false
		Sword_Video.visible = false
		Axe_Video.visible = false
	
	if ITEM_TYPE == "PICKAXE":
		EquipAnimations_Player.play("equip_PICKAXE")
		Sword_Video.visible = false
		Axe_Video.visible = false
	
	if ITEM_TYPE == "AXE":
		EquipAnimations_Player.play("equip_AXE")
		Pickaxe_Video.visible = false
		Sword_Video.visible = false
	
	if ITEM_TYPE == "SWORD":
		EquipAnimations_Player.play("equip_SWORD")
		Pickaxe_Video.visible = false
		Axe_Video.visible = false

func get_hand_debounce_time_left():
	return HandItemDebounce.time_left

func start_hand_debounce_timer():
	HandItemDebounce.start()

######################################
# Chest
######################################

func openChest():
	ChestMainLayer.show()
	InventoryManager.in_chest_interface = true
	openInventory() # Does most of the stuff for us
	InventoryManager.chestNode.animate("OPEN")

func closeChest():
	ChestMainLayer.hide()
	InventoryManager.in_chest_interface = false
	closeInventory() # Does most of the stuff for us
	InventoryManager.chestNode.animate("CLOSE")

######################################
# Pause functionality and layer
######################################

func pauseGame():
	PauseLayer.show()
	PauseManager.is_paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # set the mouse mode to visible

func resumeGame():
	PauseLayer.hide()
	PauseManager.is_paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # lock the mouse cursor

func _on_resume_btn_pressed():
	resumeGame()

func _on_settings_btn_pressed():
	SettingsUI.openSettings(0.5)

func _on_achievements_button_pressed() -> void:
	AchievementsUI.spawnAchievements(0.5)

func _on_credits_button_pressed() -> void:
	CreditsLayer.spawnCredits(0.5)

######################################
# Saving
######################################

func saveInventory():
	InventoryData.saveInventory(IslandManager.Current_Island_Name, InventoryMainLayer)

func _on_save_and_quit_btn_pressed():
	SaveManager.saveAllData()
	get_tree().quit()

func _on_save_and_quit_to_menu_pressed() -> void:
	SaveManager.saveAllData()
	transitioning_to_menu = true
	
	SleepLayerBlackOverlay.modulate = Color(1, 1, 1, 0)
	SleepLayerBlackOverlay.visible = true
	
	var tween = get_tree().create_tween()
	tween.connect("finished", Callable(self, "on_save_and_quit_to_menu_fade_finished"))
	
	tween.tween_property(SleepLayerBlackOverlay, "modulate", Color(1, 1, 1, 1), 1)
	tween.tween_interval(1)

func on_save_and_quit_to_menu_fade_finished():
	var mainMenuScene = load("res://Scenes and Scripts/Scenes/Main Menu/MainMenu.tscn")
	
	PlayerManager.WORLD.haltAllHourTweens()
	PlayerManager.WORLD.haltAllWeatherTweens()
	
	get_tree().change_scene_to_packed(mainMenuScene)

func saveAllDataWithAnimation():
	if ManualSaveCooldown.time_left == 0.0:
		ManualSaveCooldown.wait_time = 5.0
		ManualSaveCooldown.start()
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
	tween.tween_property(SaveOverlay_LighterBG, "position:x", 850.0, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func showDarkerBG_SAVEOVERLAY():
	var tween = get_tree().create_tween()
	tween.tween_property(SaveOverlay_DarkerBG, "position:x", 858.0, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func hideLighterBG_SAVEOVERLAY():
	var tween = get_tree().create_tween()
	tween.tween_property(SaveOverlay_LighterBG, "position:x", 1700.0, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)

func hideDarkerBG_SAVEOVERLAY():
	var tween = get_tree().create_tween()
	tween.tween_property(SaveOverlay_DarkerBG, "position:x", 1796.0, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)

######################################
# User Interface
######################################

func spawn_minimal_alert_from_player(holdSec : float, fadeInTime : float, fadeOutTime : float, message : String):
	MinimalAlert.spawn_minimal_alert(holdSec, fadeInTime, fadeOutTime, message)

func sleep_cycle(setSleeping : bool, incrementDay : bool, fadeInTime : float, holdTime : float, fadeOutTime : float, hour : int):
	if setSleeping:
		PlayerData.GAME_STATE = "SLEEPING"
	
	if incrementDay:
		if TimeManager.CURRENT_HOUR <= 23 and TimeManager.CURRENT_HOUR >= 18:
			TimeManager.CURRENT_DAY += 1
	
	SaveManager.saveAllData()
	
	PlayerManager.WORLD.haltAllHourTweens()
	
	DayText_Label.text = "Day " + str(TimeManager.CURRENT_DAY)
	SleepLayerBlackOverlay.modulate = Color(1, 1, 1, 0)
	SleepLayerBlackOverlay.visible = true
	ProtectiveLayer.visible = true
	
	var tween = get_tree().create_tween()
	tween.tween_property(SleepLayerBlackOverlay, "modulate", Color(1, 1, 1, 1), fadeInTime)
	tween.tween_interval(1.0)
	tween.tween_property(DayText_Label, "modulate", Color(1, 1, 1, 1), 1.0)
	
	await get_tree().create_timer(fadeInTime + holdTime).timeout
	
	on_sleep_cycle_hold_finished(fadeOutTime, hour)

func on_sleep_cycle_hold_finished(fadeOutTime, hour : int):
	
	if PlayerManager.WORLD != null:
		if PlayerManager.WORLD.has_method("set_hour"):
			
			# TASK May need to fix stuff here, if the code decides not to work (it has a mind of it's own)
			
			PlayerManager.WORLD.set_hour(hour)
	
	PlayerData.GAME_STATE = "NORMAL"
	PlayerData.Health += 5
	if PlayerData.Health > MaxHealth:
		PlayerData.Health = MaxHealth
	
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property(DayText_Label, "modulate", Color(1, 1, 1, 0), fadeOutTime / 2)
	tween.tween_property(ProtectiveLayer, "visible", false, 0)
	tween.tween_property(SleepLayerBlackOverlay, "modulate", Color(1, 1, 1, 0), fadeOutTime)
	
######################################
# Item Workshop
######################################

func openItemWorkshop():
	PauseManager.inside_can_move_item_workshop = true
	PauseManager.inside_absolute_item_workshop = true
	ItemWorkshopLayer_GreyLayer.visible = true
	ItemWorkshopLayer_GreyLayer.modulate = Color(1, 1, 1, 0)
	
	var tween = get_tree().create_tween().set_parallel()
	tween.connect("finished", Callable(self, "on_item_workshop_open_finished"))
	
	tween.tween_property(ItemWorkshopLayer_MainLayer, "position", Vector2(0, 0), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(ItemWorkshopLayer_GreyLayer, "modulate", Color(1, 1, 1, 1), 0.5)
	
	await get_tree().create_timer(0.3).timeout
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func on_item_workshop_open_finished():
	PauseManager.inside_item_workshop = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func closeItemWorkshop():
	saveInventory()
	PauseManager.inside_can_move_item_workshop = false
	PauseManager.inside_item_workshop = false
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
	var tween = get_tree().create_tween().set_parallel()
	tween.connect("finished", Callable(self, "on_item_workshop_close_finished"))
	
	tween.tween_property(ItemWorkshopLayer_MainLayer, "position", Vector2(0, 648), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(ItemWorkshopLayer_GreyLayer, "modulate", Color(1, 1, 1, 0), 0.5)

func on_item_workshop_close_finished():
	PauseManager.inside_absolute_item_workshop = false
	ItemWorkshopLayer_GreyLayer.visible = false

func on_add_item_buttons_workshop_pressed(ITEM_TYPE : String):
	
		var slots = [
			Slot1_Inventory_Ref,
			Slot2_Inventory_Ref,
			Slot_3_Inventory_Ref,
			Slot_4_Inventory_Ref,
			Slot_5_Inventory_Ref,
			Slot_6_Inventory_Ref,
			Slot_7_Inventory_Ref,
			Slot_8_Inventory_Ref,
			Slot_9_Inventory_Ref,
		]
		
		var free_slot = null
		
		# Get the free slot
		for i in range(slots.size()):
			if not slots[i].is_populated():
				free_slot = slots[i]
				break
		
		
		if free_slot != null and !free_slot.is_populated():
			
			free_slot.set_populated(true)
			
			InventoryManager.spawn_inventory_dropable(free_slot.position, ITEM_TYPE, free_slot)
		
		else:
			spawn_minimal_alert_from_player(2.5, 0.3, 0.3, "Can't add item to pockets, inventory full!")

######################################
# Area and body detection
######################################

func _on_pickup_object_detector_body_entered(body: Node3D) -> void:
	if body.is_in_group("temp_spike"):
		takeDamage(14)
	
	if body.is_in_group("item_workshop"):
		openItemWorkshop()
	
	if body.is_in_group("dialogue_test"):
		
		DialogueManager.startDialogue(DialogueManager.testDialogue)

######################################
# Player Stats
######################################

func _on_hunger_depletion_timeout() -> void:
	if !is_sprinting:
		PlayerData.Hunger -= 2
	else:
		PlayerData.Hunger -= 4
	
	if PlayerData.Hunger < 0:
		PlayerData.Hunger = 0
		
	update_bar("HUNGER", true, PlayerData.Hunger)

func update_bar(barName : String, animate : bool, toValue):
	
	if animate:
		
		if barName == "HEALTH":
			var tween = get_tree().create_tween()
			tween.tween_property(HUDLayer_HealthBar, "value", toValue, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		
		if barName == "HUNGER":
			var tween = get_tree().create_tween()
			tween.tween_property(HUDLayer_HungerBar, "value", toValue, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		
		if barName == "HYDRATION":
			pass

######################################
# Debugging
######################################

func _on_start_debugging_btn_pressed() -> void:
	if DebugManager.is_debugging:
		DebugManager.is_debugging = false
		DebugLayer.hide()
		PauseLayer.StartDebugging_Btn.text = "START DEBUGGING"
	else:
		DebugManager.is_debugging = true
		DebugLayer.show()
		PauseLayer.StartDebugging_Btn.text = "STOP DEBUGGING"
