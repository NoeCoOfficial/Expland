# ============================================================= #
# init_hand_item_SCRIPT.gd
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
# =========================================	==================== #

@tool
@icon("res://Textures/Icons/Script Icons/32x32/character_item_get.png")
extends Node3D

@export var HAND_ITEM : HandItems:
	set(value):
		HAND_ITEM = value
		if Engine.is_editor_hint():
			if %HandMesh.get_child_count() != 0:
				%HandMesh.get_child(0).queue_free()
			load_hand_item()

@onready var hand_mesh: Node3D = %HandMesh

@export var sway_noise : NoiseTexture2D
@export var sway_speed : float = 1.2
var mouse_movement : Vector2
var weapon_bob_amount := Vector2(0, 0)

var random_sway_x
var random_sway_y
var random_sway_amount : float
var time : float = 0.0
var idle_sway_adjustment
var idle_sway_rotation_strength

var goToITEM : String

func _ready() -> void:
	load_hand_item()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		init_hand_item()

func swap_items(toITEM : String, useDelay : bool = true, delayTime : float = 0.2):
	goToITEM = toITEM
	
	if useDelay:
		await get_tree().create_timer(delayTime).timeout
	
	PlayerManager.PLAYER.HandItemRig.position = Vector3(0.477, 0.0, -0.274) # Reset hand item reig position to default
	
	# If we are currently holding nothing
	if HandManager.CURRENTLY_HOLDING_ITEM == "" and goToITEM != "":
		
		if hand_mesh.get_child_count() > 0: # Check if there are any models left, if so then remove them
			for child in hand_mesh.get_children():
				child.queue_free()
		
		if toITEM != "":
			HAND_ITEM = InventoryManager.ITEM_TYPES[toITEM]["HAND_ITEM_RES"]
			position = HAND_ITEM.mesh_reset_position
			rotation_degrees = HAND_ITEM.mesh_reset_rotation
			load_hand_item()
		HandManager.CURRENTLY_HOLDING_ITEM = goToITEM
	
	# If we want to unequip everything and have empty hands
	elif goToITEM == "":
		HandManager.CURRENTLY_HOLDING_ITEM = ""
		
		if hand_mesh.get_child_count() > 0: # Check if there are any models left, if so then remove them
			for child in hand_mesh.get_children():
				child.queue_free()
	
	# If we want to equip an item and we are currently holding another item
	else:
		HandManager.CURRENTLY_HOLDING_ITEM = goToITEM
		
		if hand_mesh.get_child_count() > 0: # Check if there are any models left, if so then remove them
			for child in hand_mesh.get_children():
				child.queue_free()
		
		if goToITEM != "":
			HAND_ITEM = InventoryManager.ITEM_TYPES[goToITEM]["HAND_ITEM_RES"]
			position = HAND_ITEM.mesh_reset_position
			rotation_degrees = HAND_ITEM.mesh_reset_rotation
			load_hand_item()

func sway(delta, isIdle : bool):
	if HAND_ITEM != null:
		mouse_movement = PlayerManager.player_mouse_movement_event.clamp(HAND_ITEM.sway_min, HAND_ITEM.sway_max)
		if isIdle:
			var sway_random : float = get_sway_noise()
			var sway_random_adjusted
			
			sway_random_adjusted = sway_random * idle_sway_adjustment
			
			time += delta * (sway_speed + sway_random)
			random_sway_x = sin(time * 1.5 + sway_random_adjusted) / random_sway_amount
			random_sway_y = sin(time - sway_random_adjusted) / random_sway_amount
			
			position.x = lerp(position.x, HAND_ITEM.mesh_position.x - (mouse_movement.x *
		HAND_ITEM.sway_amount_position + random_sway_x) * delta, HAND_ITEM.sway_speed_position)
			position.y = lerp(position.y, HAND_ITEM.mesh_position.y + (mouse_movement.y *
		HAND_ITEM.sway_amount_position + random_sway_y) * delta, HAND_ITEM.sway_speed_position)
			
			rotation_degrees.y = lerp(rotation_degrees.y, HAND_ITEM.mesh_rotation.y + (mouse_movement.y *
		HAND_ITEM.sway_amount_rotation + (random_sway_y * idle_sway_rotation_strength)) * delta, HAND_ITEM.sway_speed_rotation)
			rotation_degrees.x = lerp(rotation_degrees.x, HAND_ITEM.mesh_rotation.x - (mouse_movement.x *
		HAND_ITEM.sway_amount_rotation + (random_sway_x * idle_sway_rotation_strength)) * delta, HAND_ITEM.sway_speed_rotation)
		
		else:
		
			position.x = lerp(position.x, HAND_ITEM.mesh_position.x - (mouse_movement.x *
		HAND_ITEM.sway_amount_position + weapon_bob_amount.x) * delta, HAND_ITEM.sway_speed_position)
			position.y = lerp(position.y, HAND_ITEM.mesh_position.y + (mouse_movement.y *
		HAND_ITEM.sway_amount_position + weapon_bob_amount.y) * delta, HAND_ITEM.sway_speed_position)
			
			rotation_degrees.y = lerp(rotation_degrees.y, HAND_ITEM.mesh_rotation.y + (mouse_movement.y *
		HAND_ITEM.sway_amount_rotation) * delta, HAND_ITEM.sway_speed_rotation)
			rotation_degrees.x = lerp(rotation_degrees.x, HAND_ITEM.mesh_rotation.x - (mouse_movement.x *
		HAND_ITEM.sway_amount_rotation) * delta, HAND_ITEM.sway_speed_rotation)

func get_sway_noise():
	var player_position := Vector3.ZERO
	if !Engine.is_editor_hint():
		player_position = PlayerManager.PLAYER.global_position
	
	var noise_location : float = sway_noise.noise.get_noise_2d(player_position.x, player_position.y)
	return noise_location

func bob(delta):
	if HAND_ITEM != null:
		time += delta
		
		if PlayerManager.is_walking_moving:
			weapon_bob_amount.x = sin(time * HAND_ITEM.bob_speed_walking) * HAND_ITEM.hbob_amount
			weapon_bob_amount.y = abs(cos(time * HAND_ITEM.bob_speed_walking) * HAND_ITEM.vbob_amount)
			
		if PlayerManager.is_sprinting_moving:
			weapon_bob_amount.x = sin(time * HAND_ITEM.bob_speed_sprinting) * HAND_ITEM.hbob_amount
			weapon_bob_amount.y = abs(cos(time * HAND_ITEM.bob_speed_sprinting) * HAND_ITEM.vbob_amount)
			
		if PlayerManager.is_crouching_moving:
			weapon_bob_amount.x = sin(time * HAND_ITEM.bob_speed_crouching) * HAND_ITEM.hbob_amount
			weapon_bob_amount.y = abs(cos(time * HAND_ITEM.bob_speed_crouching) * HAND_ITEM.vbob_amount)

func load_hand_item():
	if HAND_ITEM != null:
		var hand_model = HAND_ITEM.model_scene
		var hand_model_instance = hand_model.instantiate()
		
		hand_mesh.add_child(hand_model_instance)
		hand_mesh.position = HAND_ITEM.mesh_position
		hand_mesh.rotation_degrees = HAND_ITEM.mesh_rotation
		hand_mesh.scale = HAND_ITEM.mesh_scale
		idle_sway_adjustment = HAND_ITEM.idle_sway_adjustment
		idle_sway_rotation_strength = HAND_ITEM.idle_sway_rotation_strength
		random_sway_amount = HAND_ITEM.random_sway_amount
		for child in hand_model_instance.get_children():
			if child is MeshInstance3D:
				child.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

func init_hand_item():
	if HAND_ITEM != null:
		hand_mesh.position = HAND_ITEM.mesh_position
		hand_mesh.rotation_degrees = HAND_ITEM.mesh_rotation
		hand_mesh.scale = HAND_ITEM.mesh_scale
		idle_sway_adjustment = HAND_ITEM.idle_sway_adjustment
		idle_sway_rotation_strength = HAND_ITEM.idle_sway_rotation_strength
		random_sway_amount = HAND_ITEM.random_sway_amount
		
		for child in hand_mesh.get_child(0).get_children():
			if child is MeshInstance3D:
				child.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
