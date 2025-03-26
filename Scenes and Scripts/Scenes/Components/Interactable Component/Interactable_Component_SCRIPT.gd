# ============================================================= #
# Interactable_Component_SCRIPT.gd
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

extends Node3D

signal Action1_Triggered
signal Action2_Triggered
signal Action3_Triggered
signal Action4_Triggered

var interacting : bool = false

var player_in_collision_box : bool = false
var player_raycast_on : bool = false

@export var Contents_Node : Node3D
@export var SubViewport_Node : SubViewport
@export var UI_Sprite_Node : Sprite3D
@export var UI_1 : Control
@export var UI_2 : Control
@export var UI_3 : Control
@export var UI_4 : Control

@export_subgroup("Action 1")
@export var UseAction1 : bool = false
@export var ActionToPress_1 : InputEventAction

@export_subgroup("Action 2")
@export var UseAction2 : bool = false
@export var ActionToPress_2 : InputEventAction

@export_subgroup("Action 3")
@export var UseAction3 : bool = false
@export var ActionToPress_3 : InputEventAction

@export_subgroup("Action 4")
@export var UseAction4 : bool = false
@export var ActionToPress_4 : InputEventAction

func _ready() -> void:
	toggle_interacting(false)

func toggle_interacting(interacting_val : bool):
	Contents_Node.visible = interacting_val
	interacting = interacting_val

func _process(delta: float) -> void:
	if player_in_collision_box and player_raycast_on:
		toggle_interacting(true)
	else:
		toggle_interacting(false)

func _unhandled_input(event: InputEvent) -> void:
	if interacting:
		
		if UseAction1:
			if Input.is_action_just_pressed(ActionToPress_1.action):
				var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
				tween.tween_property(UI_1, "scale", Vector2(4.5, 4.5), 0.2)
		
		if UseAction1:
			if Input.is_action_just_released(ActionToPress_1.action):
				Action1_Triggered.emit()
				var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
				tween.tween_property(UI_1, "scale", Vector2(5.0, 5.0), 0.2)
				
			
			
			
		if UseAction2:
			if Input.is_action_just_pressed(ActionToPress_2.action):
				var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
				tween.tween_property(UI_2, "scale", Vector2(4.5, 4.5), 0.2)
			
		if UseAction2:
			if Input.is_action_just_released(ActionToPress_2.action):
				Action2_Triggered.emit()
				var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
				tween.tween_property(UI_2, "scale", Vector2(5.0, 5.0), 0.2)
			
			
			
		if UseAction3:
			if Input.is_action_just_pressed(ActionToPress_3.action):
				var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
				tween.tween_property(UI_3, "scale", Vector2(4.5, 4.5), 0.2)
			
		if UseAction3:
			if Input.is_action_just_released(ActionToPress_3.action):
				Action3_Triggered.emit()
				var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
				tween.tween_property(UI_3, "scale", Vector2(5.0, 5.0), 0.2)
			
			
			
		if UseAction4:
			if Input.is_action_just_pressed(ActionToPress_4.action):
				var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
				tween.tween_property(UI_4, "scale", Vector2(4.5, 4.5), 0.2)
			
		if UseAction4: 
			if Input.is_action_just_released(ActionToPress_4.action):
				Action4_Triggered.emit()
				var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
				tween.tween_property(UI_4, "scale", Vector2(5.0, 5.0), 0.2)


func _on_player_visible_detector_body_entered(body: Node3D) -> void:
	if body.is_in_group("PlayerBody"):
		player_in_collision_box = true

func _on_player_visible_detector_body_exited(body: Node3D) -> void:
	if body.is_in_group("PlayerBody"):
		player_in_collision_box = false


func _on_player_mimic_raycast_detector_area_entered(area: Area3D) -> void:
	if area.is_in_group("RayCastMimic3D"):
		player_raycast_on = true


func _on_player_mimic_raycast_detector_area_exited(area: Area3D) -> void:
	if area.is_in_group("RayCastMimic3D"):
		player_raycast_on = false
