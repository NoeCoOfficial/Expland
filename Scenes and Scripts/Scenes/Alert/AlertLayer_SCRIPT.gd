# ============================================================= #
# AlertLayer_SCRIPT.gd
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

@icon("res://Textures/Icons/Script Icons/32x32/window_dialogue.png")
extends Control

func _ready() -> void:
	Utils.set_center_offset($MainLayer/CloseButton)
	Utils.set_center_offset($MainLayer)
	
	$MainLayer.scale = Vector2(0.0, 0.0)
	self.visible = false
	$GreyLayer.modulate = Color(1, 1, 1, 0)

func spawnAlert(title : String, text : String, textFontSize : int, animationTime : float):
	PauseManager.is_inside_alert = true
	$MainLayer/Title.text = title
	$MainLayer/ScrollContainer/VBoxContainer/Text.text = text
	$MainLayer/ScrollContainer/VBoxContainer/Text.add_theme_font_size_override("font_size", textFontSize)
	
	self.visible = true
	
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($MainLayer, "scale", Vector2(1.0, 1.0), animationTime).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($GreyLayer, "modulate", Color(1, 1, 1, 1), 0.3)

func despawnAlert(animationTime : float):
	PauseManager.is_inside_alert = false
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($MainLayer, "scale", Vector2(0.0, 0.0), animationTime).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($GreyLayer, "modulate", Color(1, 1, 1, 0), 0.3)
	
	await get_tree().create_timer(0.3).timeout
	
	self.visible = false



func _on_close_button_button_down() -> void:
	pass # Replace with function body.

func _on_close_button_button_up() -> void:
	pass # Replace with function body.

func _on_close_button_mouse_exited() -> void:
	pass # Replace with function body.

func _on_close_button_mouse_entered() -> void:
	pass # Replace with function body.

func _on_close_button_pressed() -> void:
	despawnAlert(0.5)
