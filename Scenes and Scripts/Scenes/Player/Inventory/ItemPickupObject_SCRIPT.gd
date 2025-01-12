# ============================================================= #
# ItemPickupObject_SCRIPT.gd
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

@icon("res://Textures/Icons/Script Icons/32x32/item_drop.png")
extends CharacterBody3D

var gravity = 12.0
var is_picked_up = false  # Flag to indicate if the item has been picked up

@export var ITEM_TYPE: String:
	set(value):
		ITEM_TYPE = value
		PATH_TO_OBJECT = "res://Assets/3D Models/Inventory Pickup Items/" + ITEM_TYPE + ".blend"
	get:
		return ITEM_TYPE

var PATH_TO_OBJECT: String
var instantiated_object # Variable to hold the reference to the instantiated object

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	move_and_slide()

func _ready():
	self.name = "ItemPickupObject"
	self.scale = Vector3(0.0001, 0.0001, 0.0001)
	
	if InventoryManager.creatingFromInventory:
		if InventoryManager.in_chest_interface:
			self.global_position = get_node("/root/World/Player/Head/ChestItemDropPosition").global_position
		else:
			self.global_position = get_node("/root/World/Player/Head/ItemDropPosition").global_position
	
	var tween = get_tree().create_tween()
	
	if InventoryManager.creatingFromInventory:
		ITEM_TYPE = InventoryManager.item_ref
	else:
		ITEM_TYPE = InventoryManager.item_ref_not_at_inventory
	
	var LOADED_OBJECT = load(PATH_TO_OBJECT)
	
	# null checks
	if LOADED_OBJECT == null:
		print("Failed to load object: ", PATH_TO_OBJECT)
	else:
		print("{LOCAL} [ItemPickupObject_SCRIPT.gd] Object loaded successfully! Path: " + PATH_TO_OBJECT)
		
		instantiated_object = LOADED_OBJECT.instantiate() # Create an instance of the object
		self.add_child(instantiated_object) # Add it to the scene
		PlayBobbingAnimation()
		PlaySpinningAnimation()
		
		tween.tween_property(self, "scale", Vector3(0.2, 0.2, 0.2), 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func PlaySpinningAnimation():
	var tween = get_tree().create_tween()
	var current_rotation_y = instantiated_object.rotation.y
	var final_rotation_y = current_rotation_y + 2 * PI  # Rotate 360 degrees
	tween.tween_property(instantiated_object, "rotation:y", final_rotation_y, 3)
	tween.connect("finished", Callable(self, "_on_spinning_anim_finished"))

func _on_spinning_anim_finished():
	# Reset rotation to avoid floating-point precision issues
	instantiated_object.rotation.y = fmod(instantiated_object.rotation.y, 2 * PI)
	PlaySpinningAnimation()

func PlayBobbingAnimation():
	var tween = get_tree().create_tween()
	var default_y = instantiated_object.position.y
	var final_y_top = default_y + 1.5
	var time = 1.3
	tween.tween_property(instantiated_object, "position:y", final_y_top, time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(instantiated_object, "position:y", default_y, time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.connect("finished", Callable(self, "_on_bobbing_anim_finished"))

func _on_bobbing_anim_finished():
	PlayBobbingAnimation()

func get_ITEM_TYPE():
	return ITEM_TYPE

func mark_as_picked_up():
	is_picked_up = true
