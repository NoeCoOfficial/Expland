# ============================================================= #
# PalmTree_Animation_SCRIPT.gd
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

@tool
@icon("res://Textures/Icons/Script Icons/32x32/object.png")
extends Node3D

@onready var CoconutScene : PackedScene = preload("uid://6exo537gjcsd")

@export_group("General")
@export var TreeShake : AudioStreamPlayer3D
@export var WindAnimationPlayer : AnimationPlayer
@export var TreeMeshShakeAnimationPlayer : AnimationPlayer
@export var LeafShakeAnimationPlayer : AnimationPlayer

@export_group("Coconuts")
@export var CoconutSpawns : Array[Node3D]
@export var Coconut1 : RigidBody3D
@export var Coconut2 : RigidBody3D
@export var Coconut3 : RigidBody3D
@export var Coconut1_Spawn : Node3D
@export var Coconut2_Spawn : Node3D
@export var Coconut3_Spawn : Node3D
@export var Coconut1_RespawnTimer : Timer
@export var Coconut2_RespawnTimer : Timer
@export var Coconut3_RespawnTimer : Timer

var can_shake : bool = true
var coconut_info : Dictionary = {
	"Coconut1" : {
		"Dropped" : false,
		"TimeLeft" : 0.0,
	} ,
	"Coconut2" : {
		"Dropped" : false,
		"TimeLeft" : 0.0,
	} ,
	"Coconut3" : {
		"Dropped" : false,
		"TimeLeft" : 0.0,
	} 
}

func update_info() -> void:
	if coconut_info["Coconut1"]["Dropped"] == true:
		coconut_info["Coconut1"]["TimeLeft"] = Coconut1_RespawnTimer.time_left
	
	if coconut_info["Coconut2"]["Dropped"] == true:
		coconut_info["Coconut2"]["TimeLeft"] = Coconut2_RespawnTimer.time_left
	
	if coconut_info["Coconut3"]["Dropped"] == true:
		coconut_info["Coconut3"]["TimeLeft"] = Coconut3_RespawnTimer.time_left

func release_coconuts() -> void:
	# One in three chance that coconuts will drop
	if randi() % 3 == 0:
		if !coconut_info["Coconut1"]["Dropped"]:
			print("coconut 1 dropped")
			Coconut1.freeze = false
			Coconut1.reparent(IslandManager.Coconuts_WorldContents)
			coconut_info["Coconut1"]["Dropped"] = true
	
	if randi() % 3 == 0:
		if !coconut_info["Coconut2"]["Dropped"]:
			print("coconut 2 dropped")
			Coconut2.freeze = false
			Coconut2.reparent(IslandManager.Coconuts_WorldContents)
			coconut_info["Coconut2"]["Dropped"] = true
	
	if randi() % 3 == 0:
		if !coconut_info["Coconut3"]["Dropped"]:
			print("coconut 3 dropped")
			Coconut3.freeze = false
			Coconut3.reparent(IslandManager.Coconuts_WorldContents)
			coconut_info["Coconut3"]["Dropped"] = true

func _ready() -> void:
	randomize() # Only call once here
	WindAnimationPlayer.play(&"wind")

func _on_tree_shake() -> void:
	if can_shake:
		release_coconuts()
		WindAnimationPlayer.stop(true)
		var tween = get_tree().create_tween().set_parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.connect("finished", _on_leaf_tween_finished)
		
		tween.tween_property($TreeMesh/Leaf, "rotation_degrees", Vector3(-21.2, -75.0, -10.2), 0.2)
		tween.tween_property($TreeMesh/Leaf_001, "rotation_degrees", Vector3(-18.1, 122.3, -7.9), 0.2)
		tween.tween_property($TreeMesh/Leaf_002, "rotation_degrees", Vector3(6.2, -8.4, 2.4), 0.2)
		tween.tween_property($TreeMesh/Leaf_003, "rotation_degrees", Vector3(0.0, -73.4, 10.1), 0.2)
		tween.tween_property($TreeMesh/Leaf_004, "rotation_degrees", Vector3(-10.2, 52.0, 21.7), 0.2)
		tween.tween_property($TreeMesh/Leaf_005, "rotation_degrees", Vector3(-33.2, 45.0, 12.9), 0.2)
		tween.tween_property($TreeMesh/Leaf_006, "rotation_degrees", Vector3(-4.5, -30.2, -15.9), 0.2)
		tween.tween_property($TreeMesh/Leaf_007, "rotation_degrees", Vector3(6.0, -6.5, 2.5), 0.2)
		tween.tween_property($TreeMesh/Leaf_008, "rotation_degrees", Vector3(7.2, 64.9, -2.6), 0.2)
		
		TreeMeshShakeAnimationPlayer.play(&"shake")
		$TreeShake.play()
		can_shake = false
		$"Shake Debounce Timer".start()


func _on_leaf_tween_finished():
	LeafShakeAnimationPlayer.play(&"shake")

func _on_leaf_shake_animation_animation_finished(anim_name: StringName) -> void:
	WindAnimationPlayer.play(&"wind")

func _on_shake_debounce_timer_timeout() -> void:
	can_shake = true



func _on_coconut1_respawn_timer_timeout() -> void:
	pass # Replace with function body.

func _on_coconut2_respawn_timer_timeout() -> void:
	pass # Replace with function body.

func _on_coconut3_respawn_timer_timeout() -> void:
	pass # Replace with function body.
