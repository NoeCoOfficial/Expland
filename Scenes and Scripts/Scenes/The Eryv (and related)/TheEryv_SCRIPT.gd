# ============================================================= #
# TheEryv_SCRIPT.gd
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

extends CharacterBody3D
@export var NavAgent : NavigationAgent3D
@export var Player : Node3D
@export var rotation_speed : float = 5.0  # How fast the enemy rotates to face target
var CURRENT_STATE : EryvStates = EryvStates.CHASING

enum EryvStates {
	IDLE,
	CHASING
}

func update_chase_player():
	$AnimationTree.set("parameters/Transition/transition_request", "ZombieRun")
	NavAgent.set_target_position(Vector3(Player.global_position.x, 1.0, Player.global_position.z))

func _physics_process(delta: float) -> void:
	var destination = NavAgent.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	
	# Apply gravity
	velocity.y -= delta * 9.8
	
	if CURRENT_STATE == EryvStates.CHASING:
		# Move towards target
		velocity.x = direction.x * 5.0
		velocity.z = direction.z * 5.0
		
		# Face the movement direction (only if we're actually moving)
		if direction.length() > 0.1:
			# Calculate the target rotation (looking towards the direction)
			var target_rotation = atan2(direction.x, direction.z)
			
			# Smoothly rotate towards the target
			rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed * delta)
	
	move_and_slide()
