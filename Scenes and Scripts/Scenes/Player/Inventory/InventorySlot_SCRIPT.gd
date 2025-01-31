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

@export var is_populated_label : Label

@export var is_touching_draggable = false
@export var populated = false
@export var is_chest_slot = false
@export var is_workbench_slot = false

func _ready():
	modulate = Color(1, 1, 1, 0.2)

func _process(_delta):
	if !populated:
		visible = true
	else:
		visible = false
	
	if DebugManager.is_debugging:
		is_populated_label.visible = true
		if populated:
			is_populated_label.text = "Populated"
		else:
			is_populated_label.text = "Empty"
	else:
		is_populated_label.visible = false

func set_is_chest_slot(value : bool):
	is_chest_slot = value

func get_is_chest_slot():
	return is_chest_slot


func set_is_workbench_slot(value : bool):
	is_workbench_slot = value

func get_is_workbench_slot():
	return is_workbench_slot


func is_populated():
	if populated:
		return true
	else:
		return false

func set_populated(populatedValue : bool):
	if populatedValue:
		populated = true
		print("{LOCAL} [InventorySlot_SCRIPT.gd] Populated, Slot: " + str(name))
	else:
		print("{LOCAL} [InventorySlot_SCRIPT.gd] Empty, Slot: " + str(name))
		populated = false


func _on_draggable_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("draggable"):
		if $AlreadyPopulatedChecker.time_left > 0.0:
			set_populated(true)
		else:
			if !populated:
				InventoryManager.is_inside_checker = false
				
			is_touching_draggable = true

func _on_draggable_detector_area_exited(area: Area2D) -> void:
	if area.is_in_group("draggable"):
		is_touching_draggable = false
