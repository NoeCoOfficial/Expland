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
var mouse_movement : Vector2

func _ready() -> void:
	load_hand_item()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		init_hand_item()

func _physics_process(delta: float) -> void:
	#if !Engine.is_editor_hint():
		sway(delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_movement = event.relative

func sway(delta):
	mouse_movement = mouse_movement.clamp(HAND_ITEM.sway_min, HAND_ITEM.sway_max)
	
	position.x = lerp(position.x, HAND_ITEM.mesh_position.x - (mouse_movement.x *
HAND_ITEM.sway_amount_position) * delta, HAND_ITEM.sway_speed_position)
	position.y = lerp(position.y, HAND_ITEM.mesh_position.y - (mouse_movement.y *
HAND_ITEM.sway_amount_position) * delta, HAND_ITEM.sway_speed_position)
	
	rotation_degrees.y = lerp(rotation_degrees.y, HAND_ITEM.mesh_rotation.y + (mouse_movement.y *
HAND_ITEM.sway_amount_rotation) * delta, HAND_ITEM.sway_speed_rotation)
	rotation_degrees.x = lerp(rotation_degrees.x, HAND_ITEM.mesh_rotation.x + (mouse_movement.x *
HAND_ITEM.sway_amount_rotation) * delta, HAND_ITEM.sway_speed_rotation)

func load_hand_item():
	var hand_model = load(HAND_ITEM.model_path)
	var hand_model_instance = hand_model.instantiate()
	
	hand_mesh.add_child(hand_model_instance)
	hand_mesh.position = HAND_ITEM.mesh_position
	hand_mesh.rotation_degrees = HAND_ITEM.mesh_rotation
	hand_mesh.scale = HAND_ITEM.mesh_scale

func init_hand_item():
	if HAND_ITEM != null:
		hand_mesh.position = HAND_ITEM.mesh_position
		hand_mesh.rotation_degrees = HAND_ITEM.mesh_rotation
		hand_mesh.scale = HAND_ITEM.mesh_scale
