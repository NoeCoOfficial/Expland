# ============================================================= #
# InventoryDroppable_SCRIPT.gd
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

@icon("res://Textures/Icons/Script Icons/32x32/inventory.png")
extends Node2D


@export_group("Node References")

@export var Droppable_Sprite2D : Sprite2D
@export var Droppable_MouseDetector : Area2D
@export var Droppable_ITEM_TYPE_Label : Label
@export var Droppable_DebounceTimer : Timer


@export_group("Properties")

@export_subgroup("General")
@export var ITEM_TYPE : Dictionary
@export var Stack_Count : int = 1
@export var Mouse_Inside_Droppable : bool = false
@export var Debounce_Timer_0 : bool = false

@export_subgroup("Slot Related")
@export var Populating_Slot_Node : Node

# Initialize the properties. Called when a new droppable is created.
func initProperties(txt_ITEM_TYPE : String):
	ITEM_TYPE = InventoryManager.ITEM_TYPES[txt_ITEM_TYPE]
	Droppable_Sprite2D.texture = ITEM_TYPE["IMAGE_LOAD"]
	Droppable_ITEM_TYPE_Label.text = txt_ITEM_TYPE.capitalize()

# Where the magic happens.
func _process(delta: float) -> void:
	
	# First, we check if the player wants to start dragging a droppable.
	# We do is_action_pressed because it checks for every frame the input is pressed down.
	if Input.is_action_pressed("LeftClick", true):
		# Next we do some checks to make sure the player is not dragging
		# A droppable when they're not meant to.
		
		if InventoryManager.currently_dragging_node == self:
			global_position = get_global_mouse_position()
	
	# Stuff we want to happen when we drag but not every frame
	if Input.is_action_just_pressed("LeftClick", true):
		if InventoryManager.pockets_ui_open and Mouse_Inside_Droppable and Debounce_Timer_0:
			# Do this so we can communicate with the currently
			# dragging slot from all over the project.
			InventoryManager.currently_dragging_node = self
			global_position = get_global_mouse_position()
			# To show on top of all UI
			z_index = 20
			InventoryManager.is_dragging = true
	 
	# When we release the droppable. Not much done here as
	# most of the stuff happens in InventorySlot_SCRIPT.gd.
	if Input.is_action_just_released("LeftClick", true):
		if InventoryManager.pockets_ui_open and InventoryManager.is_dragging:
			InventoryManager.is_dragging = false
			InventoryManager.currently_dragging_node = null
			z_index = 0



func _on_mouse_detector_mouse_shape_entered(shape_idx: int) -> void:
	Mouse_Inside_Droppable = true
	
	# Slightly scale up the droppable for a nice effect
	if !InventoryManager.is_dragging:
		scale = Vector2(scale.x * 1.05, scale.y * 1.05)

func _on_mouse_detector_mouse_shape_exited(shape_idx: int) -> void:
	Mouse_Inside_Droppable = false
	
	# Scale down the droppable to the original size
	if !InventoryManager.is_dragging:	
		scale = Vector2(scale.x / 1.05, scale.y / 1.05)


func _on_droppable_mouse_detector_mouse_entered() -> void:
	# Reset the debounce variable then start the timer.
	# This will happen only when the player hovers over
	# the droppable.
	Debounce_Timer_0 = false
	Droppable_DebounceTimer.start()

func _on_debounce_timer_timeout() -> void:
	Debounce_Timer_0 = true
