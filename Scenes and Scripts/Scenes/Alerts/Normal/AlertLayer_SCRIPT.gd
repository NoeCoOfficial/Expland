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

@icon("uid://5ymuy8bqbfco")
extends Control

signal despawned

func _ready() -> void:
	Utils.set_center_offset($MainLayer/CloseButton)
	Utils.set_center_offset($MainLayer)
	
	$MainLayer.scale = Vector2(0.0, 0.0)
	self.visible = false
	$GreyLayer.modulate = Color(1, 1, 1, 0)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Exit") and PauseManager.is_inside_alert:
		despawned.emit()
		despawnAlert(0.5)

func spawnAlert(title : String, text : String, textFontSize : int, animationTime : float):
	PauseManager.is_inside_alert = true
	$MainLayer/Title.text = title
	$MainLayer/ScrollContainer/VBoxContainer/Text.text = text
	$MainLayer/ScrollContainer/VBoxContainer/Text.add_theme_font_size_override("font_size", textFontSize)
	
	self.visible = true
	
	if PlayerSettingsData.quickAnimations:
		$MainLayer.scale = Vector2(1.0, 1.0)
		$GreyLayer.modulate = Color(1, 1, 1, 1)
	else:
		var tween = get_tree().create_tween().set_parallel()
		tween.tween_property($MainLayer, "scale", Vector2(1.0, 1.0), animationTime).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		tween.tween_property($GreyLayer, "modulate", Color(1, 1, 1, 1), animationTime)

func despawnAlert(animationTime : float):
	PauseManager.is_inside_alert = false
	
	if str(name) == "UpdatesLayer":
		PauseManager.is_inside_updates_popup = false
	
	if PlayerSettingsData.quickAnimations:
		$MainLayer.scale = Vector2(0.0, 0.0)
		$GreyLayer.modulate = Color(1, 1, 1, 0)
		self.visible = false
	else:
		var tween = get_tree().create_tween().set_parallel()
		tween.tween_property($MainLayer, "scale", Vector2(0.0, 0.0), animationTime).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		tween.tween_property($GreyLayer, "modulate", Color(1, 1, 1, 0), animationTime)
		
		await get_tree().create_timer(animationTime).timeout
		
		self.visible = false



func popupAlert(animationTime : float):
	PauseManager.is_inside_alert = true
	
	if str(name) == "UpdatesLayer":
		PauseManager.is_inside_updates_popup = true
	
	self.visible = true
	
	if PlayerSettingsData.quickAnimations:
		$MainLayer.scale = Vector2(1.0, 1.0)
		$GreyLayer.modulate = Color(1, 1, 1, 1)
	else:
		var tween = get_tree().create_tween().set_parallel()
		tween.tween_property($MainLayer, "scale", Vector2(1.0, 1.0), animationTime).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		tween.tween_property($GreyLayer, "modulate", Color(1, 1, 1, 1), animationTime)

func _on_close_button_mouse_exited() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($MainLayer/CloseButton, "scale", Vector2(1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_close_button_mouse_entered() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($MainLayer/CloseButton, "scale", Vector2(1.15, 1.15), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_close_button_pressed() -> void:
	despawnAlert(0.5)
	despawned.emit()
