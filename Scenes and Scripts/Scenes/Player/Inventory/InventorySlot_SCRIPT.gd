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

@export var Mouse_In_Collision_Shape : bool = false

func _input(event: InputEvent) -> void:
	# What we want to happen when LeftClick is released.
	if Input.is_action_just_released("LeftClick"):
		var droppable_node_ref = InventoryManager.currently_dragging_node
		# First check if any inventories are actually open:
		if InventoryManager.pockets_ui_open:
			# Then check if we are dragging and inside the collision shape
			if InventoryManager.is_dragging and Mouse_In_Collision_Shape:
				# Check if the currently dragging node exists
				if droppable_node_ref:
					# If it does exist, add it as a child to self, 
					# setting the position to (0,0).
					
					if droppable_node_ref.get_parent():
						droppable_node_ref.get_parent().remove_child(droppable_node_ref)
					
					add_child(droppable_node_ref)
					droppable_node_ref.position = Vector2(0, 0)
					droppable_node_ref.z_index = 0

func _on_mouse_detector_mouse_shape_entered(shape_idx: int) -> void:
	Mouse_In_Collision_Shape = true

func _on_mouse_detector_mouse_shape_exited(shape_idx: int) -> void:
	Mouse_In_Collision_Shape = false
