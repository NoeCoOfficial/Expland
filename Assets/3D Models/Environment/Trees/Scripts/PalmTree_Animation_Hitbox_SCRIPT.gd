# ============================================================= #
# Tree_Animation_SCRIPT.gd
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

@icon("res://Textures/Icons/Script Icons/32x32/object.png")
extends Node3D

@export var CoconutSpawns : Array[Node3D]
@export var WindAnimationPlayer : AnimationPlayer
@export var TreeMeshShakeAnimationPlayer : AnimationPlayer
@export var LeafShakeAnimationPlayer : AnimationPlayer

func _ready() -> void:
	WindAnimationPlayer.play(&"wind")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"shake":
		WindAnimationPlayer.play(&"wind")


func _on_tree_shake() -> void:
	WindAnimationPlayer.stop(true)
	var tween = get_tree().create_tween().set_parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.connect("finished", _on_leaf_tween_finished)
	
	tween.tween_property($TreeMesh/Leaf, "rotation_degrees", Vector3(-21.2, -75.0, -10.2), 0.2)
	tween.tween_property($TreeMesh/Leaf_002, "rotation_degrees", Vector3(6.2, -8.4, 2.4), 0.2)
	tween.tween_property($TreeMesh/Leaf_003, "rotation_degrees", Vector3(0.0, -73.4, 10.1), 0.2)
	tween.tween_property($TreeMesh/Leaf_004, "rotation_degrees", Vector3(-10.2, 52.0, 21.7), 0.2)
	tween.tween_property($TreeMesh/Leaf_005, "rotation_degrees", Vector3(-33.2, 45.0, 12.9), 0.2)
	tween.tween_property($TreeMesh/Leaf_006, "rotation_degrees", Vector3(-4.5, -30.2, -15.9), 0.2)
	tween.tween_property($TreeMesh/Leaf_007, "rotation_degrees", Vector3(6.0, -6.5, 2.5), 0.2)
	tween.tween_property($TreeMesh/Leaf_008, "rotation_degrees", Vector3(7.2, 64.9, -2.6), 0.2)
	
	TreeMeshShakeAnimationPlayer.play(&"shake")

func _on_leaf_tween_finished():
	pass
