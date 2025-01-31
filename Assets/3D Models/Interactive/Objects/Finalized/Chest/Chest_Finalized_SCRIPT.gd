# ============================================================= #
# Chest_Finalized_SCRIPT.gd
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

@icon("res://Textures/Icons/Script Icons/32x32/chest.png")
extends Node3D

@export var BillboardLabel : Label3D
var ANIMATING

func _ready() -> void:
	BillboardLabel.visible = false

func _on_anim_finished(anim_name: StringName) -> void:
	
	if anim_name == &"open":
		pass
	
	elif anim_name == &"close":
		BillboardLabel.visible = true

func animate(TYPE : String):
	
	ANIMATING = true
	$DebounceTimer.start()
	
	if TYPE == "OPEN":
		$OpenAndCloseAnim.play("open")
		BillboardLabel.visible = false
	
	elif TYPE == "CLOSE":
		$OpenAndCloseAnim.play("close")

func is_animating():
	return ANIMATING


func _on_debounce_timer_timeout() -> void:
	ANIMATING = false


func _on_billboard_label_detection_body_entered(body: Node3D) -> void:
	if body.is_in_group("PlayerBody"):
		BillboardLabel.visible = true

func _on_billboard_label_detection_body_exited(body: Node3D) -> void:
	if body.is_in_group("PlayerBody"):
		BillboardLabel.visible = false
