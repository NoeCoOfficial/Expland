# ============================================================= #
# InventorySlot_SCRIPT.gd
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

@icon("res://Textures/Icons/Script Icons/32x32/ui_inventory.png")
extends StaticBody2D


@export var Populated : bool = false
@export var Populating_Droppable : Node
@export var Mouse_In_Collision_Shape : bool = false

@export var Dashed_Texture : TextureRect

func _ready() -> void:
	name = "Slot1"

func _input(event: InputEvent) -> void:
	
	var droppable_node_ref = InventoryManager.currently_dragging_node
	var is_dragging_ref = InventoryManager.is_dragging
	
	# What we want to happen when LeftClick is released.
	if Input.is_action_just_released("LeftClick"):
		# First check if any inventories are actually open:
		if InventoryManager.pockets_ui_open:
			# Then check if we are dragging, based 
			# off of the reference we made.
			if is_dragging_ref:
				# Check if the Mouse is in the collision shape
				# and if the slot is not populated by another slot
				if Mouse_In_Collision_Shape and !Populated:
					# Check if the currently dragging node exists
					if droppable_node_ref:
						# So we get the slot that is being populated  by the droppable. 
						# Then we set that slots Populated property to false, as we want to
						# Populate another slot. We then reparent the droppable to self.
						if droppable_node_ref.Populating_Slot_Node:
							droppable_node_ref.Populating_Slot_Node.Populated = false
							droppable_node_ref.Populating_Slot_Node.Populating_Droppable = null
							droppable_node_ref.Populating_Slot_Node.Dashed_Texture.self_modulate = Color(1, 1, 1, 1)
						
						droppable_node_ref.reparent(self)
						droppable_node_ref.position = Vector2(0, 0)
						Populated = true
						Populating_Droppable = droppable_node_ref
						Dashed_Texture.self_modulate = Color(1, 1, 1, 0)
						droppable_node_ref.Populating_Slot_Node = $"."
						droppable_node_ref.z_index = 0
				else:
					# This code runs if we did not release in the slot.
					# What we wanna do is, snap back to the original slot
					if droppable_node_ref.Populating_Slot_Node:
						droppable_node_ref.position = Vector2(0, 0)
						droppable_node_ref.z_index = 0

func spawn_droppable(ITEM_TYPE : String):
	var droppable_instance = InventoryManager.Droppable_Scene.instantiate()
	add_child(droppable_instance)
	droppable_instance.initProperties(ITEM_TYPE)
	droppable_instance.position = Vector2(0, 0)
	droppable_instance.Populating_Slot_Node = $"."
	droppable_instance.z_index = 0
	droppable_instance.Stack_Count = 1
	Populated = true
	Populating_Droppable = droppable_instance
	Dashed_Texture.self_modulate = Color(1, 1, 1, 0)

func _on_mouse_detector_mouse_shape_entered(shape_idx: int) -> void:
	Mouse_In_Collision_Shape = true

func _on_mouse_detector_mouse_shape_exited(shape_idx: int) -> void:
	Mouse_In_Collision_Shape = false
