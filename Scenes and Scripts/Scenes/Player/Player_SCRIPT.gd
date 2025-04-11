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

@icon("res://Textures/Icons/Script Icons/32x32/character.png")
extends CharacterBody3D

#region Variables

######################################
######################################

var loadAchivementElementsThread : Thread

######################################
######################################

@export_category("Properties")

######################################
# Utility
######################################

var speed : float ## The speed of the player. Used in _physics_process, this variable changes to SPRINT_SPEED, CROUCH_SPEED or WALK_SPEED depending on what input is pressed.
var transitioning_to_menu = false

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
# Visual group
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
var is_movement_input_active = false
var is_moving = false
var is_moving_absolute = false
var is_walking = false
var is_sprinting = false
var is_crouching = false

@export_subgroup("Crouching") ## A subgroup for crouching variables.
@export var CROUCH_JUMP_VELOCITY = 4.5 ## How much velocity the player has when jumping. The more this value is, the higher the player can jump.
@export var CROUCH_SPEED := 5.0 ## The speed of the player when the user is pressing/holding the Crouch input.
@export var CROUCH_INTERPOLATION := 6.0 ## How long it takes to go to the crouching stance or return to normal stance.

@export_subgroup("Gravity") ## A subgroup for gravity variables.
@export var gravity = 12.0 ## Was originally 9.8 (Earth's gravitational pull) but I felt it to be too unrealistic. This is the gravity of the player. The higher this value is, the faster the player falls.

@export_subgroup("Stamina")
@export var DEPLETE_STAMINA : bool = true
@export var STAMINA_DECREMENT : float
@export var STAMINA_INCREMENT : float
@export var STAMINA_MIN_ENERGY : float
var stamina_restoring_from_0 = false

######################################
######################################

@export_category("Node references")


@export_group("Body parts")

@export var head : Node3D
@export var camera : Camera3D
@export var HandItem : Node3D
@export var HandItemRig : Node3D
@export var HandAttatchmentBone : BoneAttachment3D
@export var PickupAttractionPos : Node3D

@export var Character_Body : Node3D
@export var Character_Anim_Player : AnimationPlayer

@export var Character_Shadow_Body : Node3D
@export var Character_Shadow_Anim_Player : AnimationPlayer


@export_group("Inventory")

@export_subgroup("Hotbar Slots")
@export var Slot1_Hotbar_Ref : StaticBody2D
@export var Slot2_Hotbar_Ref : StaticBody2D
@export var Slot3_Hotbar_Ref : StaticBody2D
@export var Slot4_Hotbar_Ref : StaticBody2D
@export var Slot5_Hotbar_Ref : StaticBody2D
@export var Slot6_Hotbar_Ref : StaticBody2D
@export var Slot7_Hotbar_Ref : StaticBody2D
@export var Slot8_Hotbar_Ref : StaticBody2D
@export var Slot9_Hotbar_Ref : StaticBody2D

@export_subgroup("Hotbar Outlines")
@export var Outline_Slot1_Hotbar_Ref : Panel
@export var Outline_Slot2_Hotbar_Ref : Panel
@export var Outline_Slot3_Hotbar_Ref : Panel
@export var Outline_Slot4_Hotbar_Ref : Panel
@export var Outline_Slot5_Hotbar_Ref : Panel
@export var Outline_Slot6_Hotbar_Ref : Panel
@export var Outline_Slot7_Hotbar_Ref : Panel
@export var Outline_Slot8_Hotbar_Ref : Panel
@export var Outline_Slot9_Hotbar_Ref : Panel

@export_subgroup("Pocket Slots")
@export var Slot1_Pocket_Ref : StaticBody2D
@export var Slot2_Pocket_Ref : StaticBody2D
@export var Slot3_Pocket_Ref : StaticBody2D
@export var Slot4_Pocket_Ref : StaticBody2D
@export var Slot5_Pocket_Ref : StaticBody2D
@export var Slot6_Pocket_Ref : StaticBody2D
@export var Slot7_Pocket_Ref : StaticBody2D
@export var Slot8_Pocket_Ref : StaticBody2D
@export var Slot9_Pocket_Ref : StaticBody2D
@export var Slot10_Pocket_Ref : StaticBody2D
@export var Slot11_Pocket_Ref : StaticBody2D
@export var Slot12_Pocket_Ref : StaticBody2D
@export var Slot13_Pocket_Ref : StaticBody2D
@export var Slot14_Pocket_Ref : StaticBody2D
@export var Slot15_Pocket_Ref : StaticBody2D
@export var Slot16_Pocket_Ref : StaticBody2D
@export var Slot17_Pocket_Ref : StaticBody2D
@export var Slot18_Pocket_Ref : StaticBody2D
@export var Slot19_Pocket_Ref : StaticBody2D
@export var Slot20_Pocket_Ref : StaticBody2D
@export var Slot21_Pocket_Ref : StaticBody2D
@export var Slot22_Pocket_Ref : StaticBody2D
@export var Slot23_Pocket_Ref : StaticBody2D
@export var Slot24_Pocket_Ref : StaticBody2D
@export var Slot25_Pocket_Ref : StaticBody2D

@export_subgroup("Layers and UI")
@export var InventoryLayer_CanvasLayer : CanvasLayer
@export var InventoryLayer_GreyLayer : ColorRect
@export var InventoryLayer_Pockets : Control
@export var InventoryLayer_Hotbar : Control
@export var InventoryLayer_HotbarSlotOutlines : Control
@export var InventoryLayer_Chest : Control
@export var InventoryLayer_Workbench : Control

@export var PocketsCollisionBoundary : Area2D
@export var ChestCollisionBoundary : Area2D
@export var WorkbenchCollisionBoundary : Area2D


@export_group("Chest")

@export_subgroup("Layers and UI")
@export var ChestMainLayer : Control
@export var ChestSlots : Control

@export_subgroup("Slots")
@export var Slot1_Chest_Ref : StaticBody2D
@export var Slot2_Chest_Ref : StaticBody2D
@export var Slot3_Chest_Ref : StaticBody2D
@export var Slot4_Chest_Ref : StaticBody2D
@export var Slot5_Chest_Ref : StaticBody2D
@export var Slot6_Chest_Ref : StaticBody2D
@export var Slot7_Chest_Ref : StaticBody2D
@export var Slot8_Chest_Ref : StaticBody2D
@export var Slot9_Chest_Ref : StaticBody2D
@export var Slot10_Chest_Ref : StaticBody2D
@export var Slot11_Chest_Ref : StaticBody2D
@export var Slot12_Chest_Ref : StaticBody2D
@export var Slot13_Chest_Ref : StaticBody2D
@export var Slot14_Chest_Ref : StaticBody2D
@export var Slot15_Chest_Ref : StaticBody2D
@export var Slot16_Chest_Ref : StaticBody2D
@export var Slot17_Chest_Ref : StaticBody2D
@export var Slot18_Chest_Ref : StaticBody2D
@export var Slot19_Chest_Ref : StaticBody2D
@export var Slot20_Chest_Ref : StaticBody2D
@export var Slot21_Chest_Ref : StaticBody2D
@export var Slot22_Chest_Ref : StaticBody2D
@export var Slot23_Chest_Ref : StaticBody2D
@export var Slot24_Chest_Ref : StaticBody2D
@export var Slot25_Chest_Ref : StaticBody2D
@export var Slot26_Chest_Ref : StaticBody2D
@export var Slot27_Chest_Ref : StaticBody2D
@export var Slot28_Chest_Ref : StaticBody2D
@export var Slot29_Chest_Ref : StaticBody2D
@export var Slot30_Chest_Ref : StaticBody2D
@export var Slot31_Chest_Ref : StaticBody2D
@export var Slot32_Chest_Ref : StaticBody2D
@export var Slot33_Chest_Ref : StaticBody2D
@export var Slot34_Chest_Ref : StaticBody2D
@export var Slot35_Chest_Ref : StaticBody2D
@export var Slot36_Chest_Ref : StaticBody2D
@export var Slot37_Chest_Ref : StaticBody2D
@export var Slot38_Chest_Ref : StaticBody2D
@export var Slot39_Chest_Ref : StaticBody2D
@export var Slot40_Chest_Ref : StaticBody2D
@export var Slot41_Chest_Ref : StaticBody2D
@export var Slot42_Chest_Ref : StaticBody2D
@export var Slot43_Chest_Ref : StaticBody2D
@export var Slot44_Chest_Ref : StaticBody2D
@export var Slot45_Chest_Ref : StaticBody2D
@export var Slot46_Chest_Ref : StaticBody2D
@export var Slot47_Chest_Ref : StaticBody2D
@export var Slot48_Chest_Ref : StaticBody2D
@export var Slot49_Chest_Ref : StaticBody2D


@export_group("Workbench")

@export_subgroup("Layers and UI")
@export var WorkbenchMainLayer : Control
@export var WorkbenchSlots : Control

@export_subgroup("Slots")
@export var Slot1_Workbench_Ref : StaticBody2D
@export var Slot2_Workbench_Ref : StaticBody2D
@export var Slot3_Workbench_Ref : StaticBody2D
@export var Slot4_Workbench_Ref : StaticBody2D
@export var Slot5_Workbench_Ref : StaticBody2D
@export var Slot6_Workbench_Ref : StaticBody2D
@export var Slot7_Workbench_Ref : StaticBody2D
@export var Slot8_Workbench_Ref : StaticBody2D
@export var Slot9_Workbench_Ref : StaticBody2D
@export var Slot10_Output_Workbench_Ref : StaticBody2D


@export_group("Building")
@export var BuildingUILayer : CanvasLayer
@export var BuildingUIEditLayer : CanvasLayer
@export var BuildingEditKeyMessage : Label
@export var BuildingMakeStaticMessage : Label
@export var BuildingVignette : ColorRect
@export var BuildingInitItemRig : Node3D
@export var BuildingItemParent : Node3D
@export var CanBuildCollisionArea : Area3D

@export_group("General Nodes")

@export_subgroup("CanvasLayers")
@export var HUDLayer : CanvasLayer
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
@export var Crosshair_Rect : TextureRect
@export var StaminaBar : ProgressBar
@export var EffectNotificationGrid : GridContainer

@export_subgroup("Camera")
@export var DialogueInterface : Control
@export var DeathScreen_BlackOverlay : Control
@export var OverlayLayer_Overlay : Control
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
@export var AutoSaveTimer : Timer


@export_group("Debug")

@export var StartDebugging_Btn : Button
@export var SetTime_SpinBox : SpinBox
@export var SetTime_Button : Button
@export var Is_Inside_Settings_Label : Label
@export var Is_Moving_Label : Label
@export var Is_Walking_Label : Label
@export var Is_Sprinting_Label : Label
@export var Is_Crouching_Label : Label
@export var Is_In_Dialogue_Interface_Label : Label
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
@export var CURRENT_TIME_Label : Label
@export var CURRENT_WEATHER_Label : Label
@export var CURRENT_WEATHER_ARR_INDEX_Label : Label
@export var WEATHER_TIMER_TIME_LEFT_Label : Label

#endregion

#region Input

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
			
			if !InventoryManager.pockets_ui_open and !DialogueManager.is_in_absolute_interface and !PauseManager.is_inside_alert and !PlayerData.GAME_STATE == "DEAD" and !PlayerData.GAME_STATE == "SLEEPING" and !PauseManager.inside_absolute_item_workshop and !StoryModeManager.is_in_story_mode_first_cutscene_world and !BuildingManager.is_in_building_interface:
				pauseGame()
			
			if PauseManager.inside_item_workshop:
				closeItemWorkshop()
			
			if InventoryManager.pockets_ui_open:
				InventoryManager.closePockets()
	
	# UI handling for Pockets
	if Input.is_action_just_pressed("Pockets"):
		# UI checks
		if !PauseManager.is_paused and !DialogueManager.is_in_interface and !PauseManager.inside_absolute_item_workshop and !StoryModeManager.is_in_story_mode_first_cutscene_world and !BuildingManager.is_in_building_interface:
			
			if !InventoryManager.pockets_ui_open:
				InventoryManager.openPockets()
			else:
				InventoryManager.closePockets()
	
	if Input.is_action_just_pressed("Quit") and Quit == true and OS.is_debug_build(): # if the Quit input is pressed and the Quit variable is true
		if !StoryModeManager.is_in_story_mode_first_cutscene_world:
			SaveManager.saveAllData()
		get_tree().quit() # quit the game
	
	if Input.is_action_just_pressed("Reset") and !PauseManager.inside_absolute_item_workshop and Reset == true and !PauseManager.is_paused and !PauseManager.is_inside_alert and OS.is_debug_build():
		if PlayerData.GAME_STATE == "NORMAL":
			if ResetPOS == Vector3(999, 999, 999):
				self.position = StartPOS # set the player's position to the Start position
			else:
				self.position = ResetPOS # set the player's position to the Reset position 
			velocity.y = 0.0 # set the player's velocity to 0 
	
	if Input.is_action_just_pressed("SaveGame") and OS.is_debug_build() and IslandManager.Current_Game_Mode == "FREE":
		if !StoryModeManager.is_in_story_mode_first_cutscene_world:
			Utils.take_screenshot_in_thread("user://saveData/Free Mode/Islands/" + IslandManager.Current_Island_Name + "/island.png")
			SaveManager.saveAllData()
	
	if !StoryModeManager.is_in_story_mode_first_cutscene_world and !PauseManager.is_paused and !DialogueManager.is_in_interface and !BuildingManager.is_in_building_interface:
		if Input.is_action_just_pressed("Hotbar_1"):
			InventoryManager.setSelectedHotbarSlot(Slot1_Hotbar_Ref, Outline_Slot1_Hotbar_Ref)
		if Input.is_action_just_pressed("Hotbar_2"):
			InventoryManager.setSelectedHotbarSlot(Slot2_Hotbar_Ref, Outline_Slot2_Hotbar_Ref)
		if Input.is_action_just_pressed("Hotbar_3"):
			InventoryManager.setSelectedHotbarSlot(Slot3_Hotbar_Ref, Outline_Slot3_Hotbar_Ref)
		if Input.is_action_just_pressed("Hotbar_4"):
			InventoryManager.setSelectedHotbarSlot(Slot4_Hotbar_Ref, Outline_Slot4_Hotbar_Ref)
		if Input.is_action_just_pressed("Hotbar_5"):
			InventoryManager.setSelectedHotbarSlot(Slot5_Hotbar_Ref, Outline_Slot5_Hotbar_Ref)
		if Input.is_action_just_pressed("Hotbar_6"):
			InventoryManager.setSelectedHotbarSlot(Slot6_Hotbar_Ref, Outline_Slot6_Hotbar_Ref)
		if Input.is_action_just_pressed("Hotbar_7"):
			InventoryManager.setSelectedHotbarSlot(Slot7_Hotbar_Ref, Outline_Slot7_Hotbar_Ref)
		if Input.is_action_just_pressed("Hotbar_8"):
			InventoryManager.setSelectedHotbarSlot(Slot8_Hotbar_Ref, Outline_Slot8_Hotbar_Ref)
		if Input.is_action_just_pressed("Hotbar_9"):
			InventoryManager.setSelectedHotbarSlot(Slot9_Hotbar_Ref, Outline_Slot9_Hotbar_Ref)
	
	if !StoryModeManager.is_in_story_mode_first_cutscene_world and !PauseManager.is_paused and !DialogueManager.is_in_interface and !InventoryManager.pockets_ui_open and !InventoryManager.chest_ui_open and !InventoryManager.workbench_ui_open:
		if Input.is_action_just_pressed("Building_Init"):
			BuildingManager.init_building_system()
		
		if Input.is_action_just_released("Building_Init"):
			BuildingManager.despawn_building_system()
	
	if BuildingManager.is_in_building_interface:
		if Input.is_action_just_pressed("Building_Edit"):
			if BuildingManager.is_in_building_edit_interface:
				BuildingManager.despawn_edit()
			else:
				BuildingManager.init_edit()

func _unhandled_input(event): # A built-in function that listens for input all the time
	if event is InputEventMouseMotion: # if the input is a mouse motion event
		# UI checks
		if PauseManager.is_paused or PauseManager.is_inside_alert or DialogueManager.is_in_interface or PauseManager.inside_can_move_item_workshop or InventoryManager.pockets_ui_open:
			head.rotate_y(-event.relative.x * SENSITIVITY/20) # rotate the head on the y-axis
			camera.rotate_x(-event.relative.y * SENSITIVITY/20) # rotate the camera on the x-axis
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90)) # clamp the camera rotation on the x-axis
			PlayerManager.player_mouse_movement_event_hand_item = event.relative * ((SENSITIVITY * 1000)/5)
		else:
			head.rotate_y(-event.relative.x * SENSITIVITY) # rotate the head on the y-axis
			camera.rotate_x(-event.relative.y * SENSITIVITY) # rotate the camera on the x-axis
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90)) # clamp the camera rotation on the x-axis
			PlayerManager.player_mouse_movement_event_hand_item = event.relative * (SENSITIVITY * 1000)
#endregion

#region Process

func _physics_process(delta):
	PlayerManager.isIdle = !is_movement_input_active
	HandItem.sway(delta, PlayerManager.isIdle)
	
	if PauseManager.is_paused or DialogueManager.is_in_interface or PauseManager.inside_item_workshop:
		is_sprinting = false
	
	if !is_moving_absolute:
		is_sprinting = false
	
	if is_walking and is_movement_input_active and is_moving_absolute:
		PlayerManager.is_walking_moving = true
	else:
		PlayerManager.is_walking_moving = false
	
	if is_sprinting and is_movement_input_active and is_moving_absolute:
		PlayerManager.is_sprinting_moving = true
	else:
		PlayerManager.is_sprinting_moving = false
	
	if is_crouching and is_movement_input_active and is_moving_absolute:
		PlayerManager.is_crouching_moving = true
	else:
		PlayerManager.is_crouching_moving = false

	## Player stamina
	if DEPLETE_STAMINA:
		if is_sprinting and is_movement_input_active:
			if !stamina_restoring_from_0:
				PlayerManager.Stamina -= STAMINA_DECREMENT
				if PlayerManager.Stamina <= 0.0:
					PlayerManager.Stamina = 0.0
					stamina_restoring_from_0 = true
					speed = WALK_SPEED
					is_walking = true
					is_sprinting = false
					is_crouching = false
		else:
			if !stamina_restoring_from_0 and PlayerManager.Stamina < 100.0:
				PlayerManager.Stamina += STAMINA_INCREMENT
				if PlayerManager.Stamina >= 100.0:
					PlayerManager.Stamina = 100.0
		
		if stamina_restoring_from_0:
			PlayerManager.Stamina += STAMINA_INCREMENT
			if PlayerManager.Stamina >= 50.0:
				PlayerManager.Stamina = 50.0
				stamina_restoring_from_0 = false
	else:
		if PlayerManager.Stamina < 100.0:
			PlayerManager.Stamina += STAMINA_INCREMENT
			if PlayerManager.Stamina >= 100.0:
				PlayerManager.Stamina = 100.0
	
	## Player movement and physics
	if PlayerData.GAME_STATE not in ["DEAD", "SLEEPING"] and is_on_floor() and !PauseManager.is_paused and !PauseManager.is_inside_alert and !DialogueManager.is_in_absolute_interface and !PauseManager.inside_can_move_item_workshop:
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
		if Input.is_action_just_pressed("Jump") and !Input.is_action_pressed("Crouch") and is_on_floor() and !PauseManager.inside_can_move_item_workshop and !PauseManager.is_paused and !PauseManager.is_inside_alert and PlayerData.GAME_STATE != "SLEEPING" and !DialogueManager.is_in_absolute_interface:
			velocity.y = JUMP_VELOCITY
		
		# Handle Speed
		if Input.is_action_pressed("Sprint") and !Input.is_action_pressed("Crouch"):
			if !PauseManager.inside_can_move_item_workshop and !PauseManager.is_paused and PlayerData.GAME_STATE != "SLEEPING" and !DialogueManager.is_in_absolute_interface:
				if !stamina_restoring_from_0:
					speed = SPRINT_SPEED
					is_sprinting = true
					is_crouching = false
					is_walking = false
		elif Input.is_action_pressed("Crouch"):
			if !PauseManager.inside_can_move_item_workshop and !PauseManager.is_paused and PlayerData.GAME_STATE != "SLEEPING" and !DialogueManager.is_in_absolute_interface:
				speed = CROUCH_SPEED
				is_crouching = true
				is_sprinting = false
				is_walking = false
		else:
			speed = WALK_SPEED
			is_walking = true
			is_sprinting = false
			is_crouching = false
		
		# Movement
		var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		is_movement_input_active = input_dir != Vector2.ZERO
		var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		if is_on_floor():
			if direction != Vector3.ZERO and !PauseManager.inside_can_move_item_workshop and !PauseManager.is_paused and PlayerData.GAME_STATE != "SLEEPING" and !PauseManager.is_inside_alert and !DialogueManager.is_in_absolute_interface:
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
		
		is_moving_absolute = velocity.length() > 0.1
		
		# Apply view bobbing only if the player is moving
		if is_moving:
			
			if "HASTEPOTION" in EffectManager.Current_Effects:
				Wave_Length += delta * velocity.length() / 1.5
			else:
				Wave_Length += delta * velocity.length()
			
			camera.transform.origin = _headbob(Wave_Length)
			HandItem.bob(delta)
		else:
			# Smoothly return to original position when not moving
			var target_pos = Vector3(camera.transform.origin.x, 0, camera.transform.origin.z)
			camera.transform.origin = camera.transform.origin.lerp(target_pos, delta * BOB_SMOOTHING_SPEED)
	
	_update_animation()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO # set the position to zero
	pos.y = sin(time * BOB_FREQ) * BOB_AMP # set the y position to the sine of the time times the bob frequency times the bob amplitude
	return pos # return the position

func _update_animation():
	if velocity.y == 0:
		if PlayerManager.is_sprinting_moving:
			Character_Body.fastRun()
			Character_Shadow_Body.fastRun()
		elif PlayerManager.is_walking_moving:
			Character_Body.slowRun()
			Character_Shadow_Body.slowRun()
		elif PlayerManager.is_crouching_moving:
			Character_Body.crouchWalk()
			Character_Shadow_Body.crouchWalk()
		elif is_crouching:
			Character_Body.crouchIdle()
			Character_Shadow_Body.crouchIdle()
		else:
			Character_Body.idle()
			Character_Shadow_Body.idle()
	else:
		Character_Body.fall()
		Character_Shadow_Body.fall()

func _process(_delta):
	
	SENSITIVITY = PlayerSettingsData.Sensitivity
	camera.fov = PlayerSettingsData.FOV
	StaminaBar.value = PlayerManager.Stamina
	
	## DEBUGGING
	
	# Get the time
	var time_now = Time.get_time_dict_from_system()
	var hours = time_now["hour"]
	var minutes = time_now["minute"]
	var seconds = time_now["second"]
	var time_string = str(hours).pad_zeros(2) + ":" + str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
	
	if DebugManager.is_debugging:
		SetTime_SpinBox.show()
		SetTime_Button.show()
		DebugLayer.show()
		StartDebugging_Btn.text = "STOP DEBUGGING"
		
	else:
		SetTime_SpinBox.hide()
		SetTime_Button.hide()
		DebugLayer.hide()
		StartDebugging_Btn.text = "START DEBUGGING"
	
	Is_Inside_Settings_Label.text = "is_inside_settings = " + str(PauseManager.is_inside_settings)
	Is_Moving_Label.text = "is_moving = " + str(is_moving)
	Is_Walking_Label.text = "is_walking = " + str(is_walking)
	Is_Sprinting_Label.text = "is_sprinting = " + str(is_sprinting)
	Is_Crouching_Label.text = "is_crouching = " + str(is_crouching)
	Is_In_Dialogue_Interface_Label.text = "In dialogue interface? " + str(DialogueManager.is_in_interface)
	Current_Time_Label.text = time_string
	Current_FPS_Label.text = "FPS: %d" % Engine.get_frames_per_second()
	Player_Position_Label.text = "Player position: " + str(self.position)
	Player_VelocityY_Label.text = "velocity.y = " + str(round(velocity.y))
	Player_VelocityY_Accurate_Label.text = str(velocity.y)
	Is_On_Floor_Label.text = "is_on_floor() = " + str(is_on_floor())
	DAY_STATE_Label.text = "DAY_STATE = " + TimeManager.DAY_STATE
	GAME_STATE_Label.text = "GAME_STATE = " + PlayerData.GAME_STATE
	CURRENT_DAY_Label.text = "CURRENT_DAY = " + str(TimeManager.CURRENT_DAY)
	CURRENT_TIME_Label.text = "CURRENT_TIME = " + str(TimeManager.CURRENT_TIME)
	CURRENT_WEATHER_Label.text = "CURRENT_WEATHER = " + str(WeatherManager.CURRENT_WEATHER)
	CURRENT_WEATHER_ARR_INDEX_Label.text = "CURRENT_WEATHER_ARR_INDEX = " + str(WeatherManager.CURRENT_WEATHER_ARR_INDEX)
	WEATHER_TIMER_TIME_LEFT_Label.text = "WEATHER_TIMER_TIME_LEFT = " + str(WeatherManager.WEATHER_TIMER_TIME_LEFT)
	
	## END DEBUGGING
	
	# HUD
	if UseHealth == false: # Check if the UseHealth variable is false
		HUDLayer_HealthBar.hide()
	else: 
		HUDLayer_HealthBar.show()
	
	
	# NOTE: Change when making crosshair setting
	Crosshair_Rect.size = crosshair_size # set the crosshair size to the crosshair size variable

#endregion

#region On startup

func _ready():
	PlayerManager.PLAYER = $"."
	PlayerManager.MINIMAL_ALERT_PLAYER = MinimalAlert
	
	initInventorySlots() # Link local inventory slots to singleton arrays
	init_for_story_mode_cutscene()
	
	HandManager.HAND_ITEM_NODE = HandItem
	
	GlobalData.loadGlobal()
	
	AchievementsManager.CURRENT_UI_GRID_CONTAINER = $Head/Camera3D/AchievementsLayer/AchievementsUI/MainLayer/ScrollContainer/GridContainer
	AchievementsManager.CURRENT_ACHIEVEMENTS_UI = $Head/Camera3D/AchievementsLayer/AchievementsUI
	AchievementsManager.CURRENT_NOTIFICATION_NODE = $Head/Camera3D/AchievementNotificationLayer/AchievementNotification
	
	loadAchivementElementsThread = Thread.new()
	var loadAchivementElementsThread_callable = Callable(AchievementsManager, "populateGridContainer")
	loadAchivementElementsThread.start(loadAchivementElementsThread_callable)
	loadAchivementElementsThread.wait_to_finish()
	
	PlayerManager.AudioNotification = $Head/Camera3D/AudioNotificationLayer/AudioNotification
	
	DialogueManager.MinimalDialogueInterface = $Head/Camera3D/MinimalDialogueLayer/MinimalDialogue
	DialogueManager.DialogueInterface = DialogueInterface
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Lock mouse
	$Head/Camera3D/AutosaveLayer/AutosaveMainLayer/Saving/SpinningAnimation.play(&"spin")
	
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
	
	if !OS.is_debug_build():
		PauseLayer.hide()
		StartDebugging_Btn.hide()
	

func on_fade_in_tween_finished():
	if !StoryModeManager.is_in_story_mode_first_cutscene_world:
		if IslandManager.Current_Game_Mode == "FREE":
			Utils.take_screenshot_in_thread("user://saveData/Free Mode/Islands/" + IslandManager.Current_Island_Name + "/island.png")

func _on_ready() -> void: # Called when the node is considered ready
	pass

func nodeSetup(): # A function to setup the nodes. Called in the _ready function
	HUDLayer_HungerBar.value = PlayerData.Hunger
	HUDLayer_HealthBar.value = PlayerData.Health
	setAutosaveInterval(PlayerSettingsData.autosaveInterval)
	
	GetUp_Label.self_modulate = Color(0, 0, 0, 0) # set the get up self modulate to black
	RandomText_Label.self_modulate = Color(0, 0, 0, 0) # set the random text self modulate to black
	DeathScreen_BlackOverlay.self_modulate = Color(0, 0, 0, 0) # set the black overlay self modulate to black
	OverlayLayer_RedOverlay.self_modulate = Color(1, 0.016, 0, 0) # set the red overlay self modulate to red

func initInventorySlots():
	InventoryManager.POCKET_SLOTS = [
		Slot1_Pocket_Ref,
		Slot2_Pocket_Ref,
		Slot3_Pocket_Ref,
		Slot4_Pocket_Ref,
		Slot5_Pocket_Ref,
		Slot6_Pocket_Ref,
		Slot7_Pocket_Ref,
		Slot8_Pocket_Ref,
		Slot9_Pocket_Ref,
		Slot10_Pocket_Ref,
		Slot11_Pocket_Ref,
		Slot12_Pocket_Ref,
		Slot13_Pocket_Ref,
		Slot14_Pocket_Ref,
		Slot15_Pocket_Ref,
		Slot16_Pocket_Ref,
		Slot17_Pocket_Ref,
		Slot18_Pocket_Ref,
		Slot19_Pocket_Ref,
		Slot20_Pocket_Ref,
		Slot21_Pocket_Ref,
		Slot22_Pocket_Ref,
		Slot23_Pocket_Ref,
		Slot24_Pocket_Ref,
		Slot25_Pocket_Ref,
	]
	
	InventoryManager.HOTBAR_SLOTS = [
		Slot1_Hotbar_Ref,
		Slot2_Hotbar_Ref,
		Slot3_Hotbar_Ref,
		Slot4_Hotbar_Ref,
		Slot5_Hotbar_Ref,
		Slot6_Hotbar_Ref,
		Slot7_Hotbar_Ref,
		Slot8_Hotbar_Ref,
		Slot9_Hotbar_Ref,
	]
	
	InventoryManager.CHEST_SLOTS = [
		Slot1_Chest_Ref,
		Slot2_Chest_Ref,
		Slot3_Chest_Ref,
		Slot4_Chest_Ref,
		Slot5_Chest_Ref,
		Slot6_Chest_Ref,
		Slot7_Chest_Ref,
		Slot8_Chest_Ref,
		Slot9_Chest_Ref,
		Slot10_Chest_Ref,
		Slot11_Chest_Ref,
		Slot12_Chest_Ref,
		Slot13_Chest_Ref,
		Slot14_Chest_Ref,
		Slot15_Chest_Ref,
		Slot16_Chest_Ref,
		Slot17_Chest_Ref,
		Slot18_Chest_Ref,
		Slot19_Chest_Ref,
		Slot20_Chest_Ref,
		Slot21_Chest_Ref,
		Slot22_Chest_Ref,
		Slot23_Chest_Ref,
		Slot24_Chest_Ref,
		Slot25_Chest_Ref,
		Slot26_Chest_Ref,
		Slot27_Chest_Ref,
		Slot28_Chest_Ref,
		Slot29_Chest_Ref,
		Slot30_Chest_Ref,
		Slot31_Chest_Ref,
		Slot32_Chest_Ref,
		Slot33_Chest_Ref,
		Slot34_Chest_Ref,
		Slot35_Chest_Ref,
		Slot36_Chest_Ref,
		Slot37_Chest_Ref,
		Slot38_Chest_Ref,
		Slot39_Chest_Ref,
		Slot40_Chest_Ref,
		Slot41_Chest_Ref,
		Slot42_Chest_Ref,
		Slot43_Chest_Ref,
		Slot44_Chest_Ref,
		Slot45_Chest_Ref,
		Slot46_Chest_Ref,
		Slot47_Chest_Ref,
		Slot48_Chest_Ref,
		Slot49_Chest_Ref,
	]
	
	InventoryManager.WORKBENCH_SLOTS = [
		Slot1_Workbench_Ref,
		Slot2_Workbench_Ref,
		Slot3_Workbench_Ref,
		Slot4_Workbench_Ref,
		Slot5_Workbench_Ref,
		Slot6_Workbench_Ref,
		Slot7_Workbench_Ref,
		Slot8_Workbench_Ref,
		Slot9_Workbench_Ref,
	]
	
	InventoryManager.WORKBENCH_OUTPUT_SLOT = Slot10_Output_Workbench_Ref

func init_for_story_mode_cutscene():
	if StoryModeManager.is_in_story_mode_first_cutscene_world:
		UseHealth = false
		head.rotation_degrees.y = -125.3
		camera.rotation_degrees.x = -6.0
		$Head/Camera3D/HUDLayer/HungerBar.hide()
		$Head/Camera3D/HUDLayer/HealthBar.hide()
		$Head/Camera3D/HUDLayer/StaminaBar.hide()
		$Head/Camera3D/HUDLayer/WhiteHamIcon.hide()
		$Head/Camera3D/HUDLayer/WhiteHeartIcon.hide()
		InventoryLayer_Hotbar.hide()

#endregion

#region Walking, sprinting and crouching sounds

func _on_walking_speed_sounds_timeout() -> void:
	if PlayerManager.is_walking_moving and velocity.y == 0.0:
		play_footstep_sounds_terrain()

func _on_sprinting_speed_sounds_timeout() -> void:
	if PlayerManager.is_sprinting_moving and velocity.y == 0.0:
		play_footstep_sounds_terrain()

func _on_crouching_speed_sounds_timeout() -> void:
	if PlayerManager.is_crouching_moving and velocity.y == 0.0:
		play_footstep_sounds_terrain()

func play_footstep_sounds_terrain():
	# Default sound
	if TerrainManager.on_terrain == "":
		$"Footstep Sounds/Footstep_Sounds_STONE".play_random()
	
	else:
		if TerrainManager.on_terrain == "GRASS":
			$"Footstep Sounds/Footstep_Sounds_GRASS".play_random()
		elif TerrainManager.on_terrain == "STONE":
			$"Footstep Sounds/Footstep_Sounds_STONE".play_random()
			
#endregion

#region Health and dying management

func takeDamage(DamageToTake): # A function to take damage from the player
	if UseHealth == true: # Check if the UseHealth variable is true
		PlayerData.Health -= DamageToTake # subtract the damage to take from the health variable
		
		if PlayerData.Health <= 0:
			update_bar("HEALTH", true, 0)
			
		else:
			update_bar("HEALTH", true, PlayerData.Health)
		
		if PlayerData.Health <= 0: # check if health = 0 or below
			
			
			PlayerData.GAME_STATE = "DEAD" # set the player data's game state to dead
			PlayerData.Health = 0 # set the health to 0
			
			resumeGame()
			closeItemWorkshop()
			SettingsUI.closeSettings(0.5)
			AlertLayer.despawnAlert(0.5)
			AchievementsUI.despawnAchievements(0.5)
			CreditsLayer.despawnCredits(0.5)
			MinimalAlert.hide_minimal_alert(0.1)
			AudioManager.Current_Playlist.audibleOnlyFadeOutAllSongs()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # lock mouse
			
			showDeathScreen() # call the death screen function 
			
		else:
			takeDamageOverlay() # call the take damage overlay function

func takeDamageOverlay(): # Overlay when taking damage 
	var tween = get_tree().create_tween() # create a tween
	tween.tween_property(OverlayLayer_RedOverlay, "self_modulate", Color(1, 0.018, 0, 0.808), 0).from(Color(1, 0.016, 0, 0)) # tween the red overlay's self modulate to red
	tween.tween_property(OverlayLayer_RedOverlay, "self_modulate", Color(1, 0.016, 0, 0), 0.5) # tween the red overlay's self modulate to red

func respawnFromDeath(): # A function to respawn the player from death
	self.position = StartPOS # set the player's position to the start position
	PlayerData.Health = MaxHealth # set the health to the max health
	PlayerData.Hunger = 100
	update_bar("HEALTH", true, PlayerData.Health)
	update_bar("HUNGER", true, PlayerData.Hunger)
	
	var tween = get_tree().create_tween() # create a tween

	tween.tween_property(DeathScreen_BlackOverlay, "self_modulate", Color(0, 0, 0, 0), 3) # tween the black overlay's self modulate to black
	AudioManager.Current_Playlist.audibleOnlyFadeInAllSongs()
	PlayerData.GAME_STATE = "NORMAL" # set the game state to normal

func _on_death_screen_finished(): # A function to call when the death screen is finished 
	respawnFromDeath() # call the respawn from death function

func showDeathScreen(): # A function to show the death screen 
	randomize()  # seed the random number generator
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

#endregion

#region Building

func _on_can_build_collision_area_body_entered(body: Node3D) -> void:
	BuildingManager.toggle_can_build(false, true)

func _on_can_build_collision_area_body_exited(body: Node3D) -> void:
	BuildingManager.toggle_can_build(true, true)

#endregion

#region Item Workshop

func openItemWorkshop():
	PauseManager.inside_can_move_item_workshop = true
	PauseManager.inside_absolute_item_workshop = true
	ItemWorkshopLayer_GreyLayer.visible = true
	ItemWorkshopLayer_GreyLayer.modulate = Color(1, 1, 1, 0)
	
	var tween = get_tree().create_tween().set_parallel()
	tween.connect("finished", Callable(self, "on_item_workshop_open_finished"))
	
	
	tween.tween_property(ItemWorkshopLayer_MainLayer, "position", Vector2(0, 0), 0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(ItemWorkshopLayer_GreyLayer, "modulate", Color(1, 1, 1, 1), 0)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func on_item_workshop_open_finished():
	PauseManager.inside_item_workshop = true

func closeItemWorkshop():
	PauseManager.inside_can_move_item_workshop = false
	PauseManager.inside_item_workshop = false
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	var tween = get_tree().create_tween().set_parallel()
	tween.connect("finished", Callable(self, "on_item_workshop_close_finished"))
	
	tween.tween_property(ItemWorkshopLayer_MainLayer, "position", Vector2(0, 648), 0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(ItemWorkshopLayer_GreyLayer, "modulate", Color(1, 1, 1, 0), 0)

func on_item_workshop_close_finished():
	PauseManager.inside_absolute_item_workshop = false
	ItemWorkshopLayer_GreyLayer.visible = false

func on_add_item_buttons_workshop_pressed(ITEM_TYPE : String):
	var free_slot = InventoryManager.get_free_slot_using_stacks(
		InventoryManager.POCKET_SLOTS,
		ITEM_TYPE)
	
	if free_slot != null:
		free_slot.spawn_droppable(ITEM_TYPE)

#endregion

#region Potions and Effects

func init_effect(E_name : String):
	if E_name == "HASTEPOTION":
		WALK_SPEED *= 1.5
		SPRINT_SPEED *= 1.5
		CROUCH_SPEED *= 1.5
	
	if E_name == "STAMINAPOTION":
		DEPLETE_STAMINA = false

func stop_effect(E_name : String):
	if E_name == "HASTEPOTION":
		WALK_SPEED /= 1.5
		SPRINT_SPEED /= 1.5
		CROUCH_SPEED /= 1.5
		
	if E_name == "STAMINAPOTION":
		DEPLETE_STAMINA = true

func _on_potion_health_regen_timeout() -> void:
	if "HEALTHPOTION" in EffectManager.Current_Effects:
		PlayerData.Health += 7
		if PlayerData.Health >= 100:
			PlayerData.Health = 100
		update_bar("HEALTH", true, PlayerData.Health)

#endregion

#region Pausing

func pauseGame():
	PauseLayer.show()
	$Head/Camera3D/AudioNotificationLayer.layer = 15
	PauseManager.is_paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # set the mouse mode to visible

func resumeGame():
	PauseLayer.hide()
	$Head/Camera3D/AudioNotificationLayer.layer = 1
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

#endregion

#region Saving

func _on_save_and_quit_btn_pressed():
	if !StoryModeManager.is_in_story_mode_first_cutscene_world:
		SaveManager.saveAllData()
	get_tree().quit()

func _on_save_and_quit_to_menu_pressed() -> void:
	if !StoryModeManager.is_in_story_mode_first_cutscene_world:
		SaveManager.saveAllData()
	transitioning_to_menu = true
	Global.the_island_transitioning_scene = true
	AudioManager.Current_Playlist.audibleOnlyFadeOutAllSongs()
	if AudioManager.Current_Rain_SFX_Node:
		AudioManager.Current_Rain_SFX_Node.stop_rain_loop(2.0)
	
	ProtectiveLayer.show()
	$Head/Camera3D/SleepLayer.layer = 100
	SleepLayerBlackOverlay.modulate = Color(1, 1, 1, 0)
	SleepLayerBlackOverlay.visible = true
	
	var tween = get_tree().create_tween()
	tween.connect("finished", Callable(self, "on_save_and_quit_to_menu_fade_finished"))
	
	tween.tween_property(SleepLayerBlackOverlay, "modulate", Color(1, 1, 1, 1), 1)
	tween.tween_interval(1)

func on_save_and_quit_to_menu_fade_finished():
	var mainMenuScene = load("res://Scenes and Scripts/Scenes/Main Menu/MainMenu.tscn")
	
	get_tree().change_scene_to_packed(mainMenuScene)

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

#endregion

#region Autosave

func _on_auto_save_timer_timeout(): # A function to save the player data every x seconds
	if !StoryModeManager.is_in_story_mode_first_cutscene_world:
		if !PauseManager.is_paused and !PlayerData.GAME_STATE == "DEAD" and !PlayerData.GAME_STATE == "SLEEPING" and !transitioning_to_menu:
			Autosave_showSaving()

func Autosave_showSaving():
	$Head/Camera3D/AutosaveLayer/AutosaveMainLayer/Saved.visible = false
	$Head/Camera3D/AutosaveLayer/AutosaveMainLayer/Saving.visible = true
	$Head/Camera3D/AutosaveLayer/AutosaveMainLayer/Saving.scale = Vector2(0.83, 0.83)
	$Head/Camera3D/AutosaveLayer/AutosaveMainLayer/Saving.modulate = Color(1, 1, 1, 0)
	
	var tween = get_tree().create_tween().set_parallel()
	tween.connect("finished", Callable(self, "Autosave_showSaved"))
	tween.tween_property($Head/Camera3D/AutosaveLayer/AutosaveMainLayer/Saving, "modulate", Color(1, 1, 1, 1), 0.2)
	tween.tween_property($Head/Camera3D/AutosaveLayer/AutosaveMainLayer/Saving, "scale", Vector2(1.0, 1.0), 0.2)
	tween.tween_interval(4.0)

func Autosave_showSaved():
	if !StoryModeManager.is_in_story_mode_first_cutscene_world:
		SaveManager.saveAllData() # Saves everything
		Utils.take_screenshot_in_thread("user://saveData/Free Mode/Islands/" + IslandManager.Current_Island_Name + "/island.png") # Take island screenshot
		
		$Head/Camera3D/AutosaveLayer/AutosaveMainLayer/Saved.visible = true
		$Head/Camera3D/AutosaveLayer/AutosaveMainLayer/Saved.scale = Vector2(0.83, 0.83)
		$Head/Camera3D/AutosaveLayer/AutosaveMainLayer/Saved.modulate = Color(1, 1, 1, 0)
		
		var tween = get_tree().create_tween().set_parallel()
		tween.tween_property($Head/Camera3D/AutosaveLayer/AutosaveMainLayer/Saving, "modulate", Color(1, 1, 1, 0), 0.2)
		tween.tween_property($Head/Camera3D/AutosaveLayer/AutosaveMainLayer/Saving, "scale", Vector2(0.83, 0.83), 0.2)
		tween.tween_property($Head/Camera3D/AutosaveLayer/AutosaveMainLayer/Saved, "modulate", Color(1, 1, 1, 1), 0.2).set_delay(0.2)
		tween.tween_property($Head/Camera3D/AutosaveLayer/AutosaveMainLayer/Saved, "scale", Vector2(1.0, 1.0), 0.2).set_delay(0.2)
		
		tween.tween_property($Head/Camera3D/AutosaveLayer/AutosaveMainLayer/Saved, "modulate", Color(1, 1, 1, 0), 0.2).set_delay(3.2)
		tween.tween_property($Head/Camera3D/AutosaveLayer/AutosaveMainLayer/Saved, "scale", Vector2(0.83, 0.83), 0.2).set_delay(3.2)

func setAutosaveInterval(value : int):
	AutoSaveTimer.stop()
	AutoSaveTimer.wait_time = value
	AutoSaveTimer.start()

#endregion

#region User Interface

func spawn_minimal_alert_from_player(holdSec : float, fadeInTime : float, fadeOutTime : float, message : String):
	MinimalAlert.spawn_minimal_alert(holdSec, fadeInTime, fadeOutTime, message)

func sleep_cycle(setSleeping : bool, incrementDay : bool, fadeInTime : float, holdTime : float, fadeOutTime : float, time : int):
	if setSleeping:
		PlayerData.GAME_STATE = "SLEEPING"
	
	if incrementDay:
		if TimeManager.CURRENT_TIME < 1440 and TimeManager.CURRENT_TIME >= 1080:
			TimeManager.CURRENT_DAY = int(TimeManager.CURRENT_DAY + 1)
	
	SaveManager.saveAllData()
	
	DayText_Label.text = "Day " + str(TimeManager.CURRENT_DAY)
	SleepLayerBlackOverlay.modulate = Color(1, 1, 1, 0)
	SleepLayerBlackOverlay.visible = true
	ProtectiveLayer.visible = true
	
	var tween = get_tree().create_tween()
	tween.tween_property(SleepLayerBlackOverlay, "modulate", Color(1, 1, 1, 1), fadeInTime)
	tween.tween_interval(1.0)
	tween.tween_property(DayText_Label, "modulate", Color(1, 1, 1, 1), 1.0)
	
	await get_tree().create_timer(fadeInTime + holdTime).timeout
	
	on_sleep_cycle_hold_finished(fadeOutTime, time)

func on_sleep_cycle_hold_finished(fadeOutTime, time : int):
	
	if PlayerManager.WORLD != null:
		if PlayerManager.WORLD.has_method("set_time"):
			PlayerManager.WORLD.set_time(time)
	
	PlayerData.GAME_STATE = "NORMAL"
	PlayerData.Health += 10
	
	if PlayerData.Health > MaxHealth:
		PlayerData.Health = MaxHealth
	
	update_bar("HEALTH", true, PlayerData.Health)
	
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property(DayText_Label, "modulate", Color(1, 1, 1, 0), fadeOutTime / 2)
	tween.tween_property(ProtectiveLayer, "visible", false, 0).set_delay(1.0)
	tween.tween_property(SleepLayerBlackOverlay, "modulate", Color(1, 1, 1, 0), fadeOutTime).set_delay(1.0)

#endregion

#region Area and body detection

func _on_area_collision_shape_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("temp_spike"):
		takeDamage(14)
		
	if body.is_in_group("temp_spike_ik"):
		takeDamage(100)

func _on_area_collision_shape_3d_area_entered(area: Area3D) -> void:
	pass

#endregion

#region Player Stats

func _on_health_regen_timeout() -> void:
	if PlayerData.GAME_STATE != "DEAD":
		if PlayerManager.is_sprinting_moving:
			PlayerData.Health += 5
		else:
			PlayerData.Health += 10
		
	if PlayerData.Health > MaxHealth:
		PlayerData.Health = MaxHealth
		
	update_bar("HEALTH", true, PlayerData.Health)

func _on_hunger_depletion_timeout() -> void:
	if !PlayerManager.is_sprinting_moving:
		PlayerData.Hunger -= 2
	else:
		PlayerData.Hunger -= 4
	
	if PlayerData.Hunger < 0:
		PlayerData.Hunger = 0
		
	update_bar("HUNGER", true, PlayerData.Hunger)

func _on_health_depleting_from_hunger_timeout() -> void:
	if PlayerData.Hunger <= 0:
		takeDamage(10)

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

#endregion

#region Debugging

func _on_start_debugging_btn_pressed() -> void:
	if DebugManager.is_debugging:
		DebugManager.is_debugging = false
	else:
		DebugManager.is_debugging = true

func _on_set_time_button_pressed() -> void:
	TimeManager.CURRENT_TIME = SetTime_SpinBox.value
	PlayerManager.WORLD.set_time(SetTime_SpinBox.value)

#endregion
