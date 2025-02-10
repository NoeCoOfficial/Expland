# ============================================================= #
# RayCast3D_SCRIPT.gd
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

extends RayCast3D

var previous_collider = null

func _physics_process(_delta: float) -> void:
	if is_colliding():
		var collider = get_collider()
		if collider != previous_collider:
			
			
			if previous_collider and previous_collider.has_method("on_raycast_exit_test_obj"):
				previous_collider.on_raycast_exit_test_obj()
				InteractionManager.despawn_interaction_notification()
			
			elif previous_collider and previous_collider.has_method("on_raycast_hit_email_noeco"):
				previous_collider.on_raycast_hit_email_noeco()
				InteractionManager.despawn_interaction_notification()
			
			elif previous_collider and previous_collider.has_method("on_raycast_hit_feedback_github"):
				previous_collider.on_raycast_hit_feedback_github()
				InteractionManager.despawn_interaction_notification()
			
			elif previous_collider and previous_collider.has_method("on_raycast_hit_sackcloth_bed"):
				previous_collider.on_raycast_hit_sackcloth_bed()
				InteractionManager.despawn_interaction_notification()
			
			elif previous_collider and previous_collider.has_method("on_raycast_hit_chest"):
				previous_collider.on_raycast_hit_chest()
				InteractionManager.despawn_interaction_notification()
			
			elif previous_collider and previous_collider.has_method("on_raycast_hit_workbench"):
				previous_collider.on_raycast_hit_workbench()
				InteractionManager.despawn_interaction_notification()
			
			elif previous_collider and previous_collider.has_method("on_raycast_hit_explorer_note"):
				previous_collider.on_raycast_hit_explorer_note()
				previous_collider.get_parent()
				InteractionManager.despawn_interaction_notification()
			
			
			if collider and collider.has_method("on_raycast_hit_test_obj"):
				InteractionManager.spawn_interaction_notification("F", "Interact")
				collider.on_raycast_hit_test_obj()
			
			elif collider and collider.has_method("on_raycast_hit_email_noeco"):
				InteractionManager.spawn_interaction_notification("F", "Email")
				collider.on_raycast_hit_email_noeco()
			
			elif collider and collider.has_method("on_raycast_hit_feedback_github"):
				InteractionManager.spawn_interaction_notification("F", "Open")
				collider.on_raycast_hit_feedback_github()
			
			elif collider and collider.has_method("on_raycast_hit_sackcloth_bed"):
				InteractionManager.spawn_interaction_notification("F", "Sleep")
				collider.on_raycast_hit_sackcloth_bed()
			
			elif collider and collider.has_method("on_raycast_hit_chest"):
				InteractionManager.spawn_interaction_notification("F", "Open")
				collider.on_raycast_hit_chest()
			
			elif collider and collider.has_method("on_raycast_hit_workbench"):
				InteractionManager.spawn_interaction_notification("F", "Craft")
				collider.on_raycast_hit_workbench()
			
			elif collider and collider.has_method("on_raycast_hit_explorer_note"):
				InteractionManager.spawn_interaction_notification("F", "Read")
				collider.on_raycast_hit_explorer_note()
			
			previous_collider = collider
		
		
	else:
		
		
		if previous_collider and previous_collider.has_method("on_raycast_exit_test_obj"):
			previous_collider.on_raycast_exit_test_obj()
			InteractionManager.despawn_interaction_notification()
		
		elif previous_collider and previous_collider.has_method("on_raycast_exit_email_noeco"):
			previous_collider.on_raycast_exit_email_noeco()
			InteractionManager.despawn_interaction_notification()
		
		elif previous_collider and previous_collider.has_method("on_raycast_exit_feedback_github"):
			previous_collider.on_raycast_exit_feedback_github()
			InteractionManager.despawn_interaction_notification()
		
		elif previous_collider and previous_collider.has_method("on_raycast_exit_sackcloth_bed"):
			previous_collider.on_raycast_exit_sackcloth_bed()
			InteractionManager.despawn_interaction_notification()
		
		elif previous_collider and previous_collider.has_method("on_raycast_exit_chest"):
			previous_collider.on_raycast_exit_chest()
			InteractionManager.despawn_interaction_notification()
		
		elif previous_collider and previous_collider.has_method("on_raycast_exit_workbench"):
			previous_collider.on_raycast_exit_workbench()
			InteractionManager.despawn_interaction_notification()
		
		elif previous_collider and previous_collider.has_method("on_raycast_exit_explorer_note"):
			previous_collider.on_raycast_exit_explorer_note()
			InteractionManager.despawn_interaction_notification()
		
		previous_collider = null
		InteractionManager.is_colliding = false
