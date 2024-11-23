# ============================================================= #
# DialogueInterface_SCRIPT.gd
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

@icon("res://Textures/Icons/Script Icons/32x32/dialogue.png")
extends Control

@export var GreyLayer : ColorRect
@export var DialogueBoxButton : Button
@export var PersonLabel : Label
@export var MessageLabel : Label

var finished_displaying_text = false
var is_animating = false
var is_animating_text = false
var spawnTween

func _ready() -> void:
	self.visible = false
	
	GreyLayer.visible = false
	GreyLayer.modulate = Color(1, 1, 1, 0)
	
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("LeftClick") and DialogueManager.is_in_interface and MessageLabel.visible_ratio == 1:
		despawnDialogue()

func showGreyOverlay(Duration : float):
	GreyLayer.visible = true
	
	var tween = get_tree().create_tween()
	tween.tween_property(GreyLayer, "modulate", Color(1, 1, 1, 1), Duration)

func hideGreyOverlay(Duration : float):
	
	var tween = get_tree().create_tween()
	tween.tween_property(GreyLayer, "modulate", Color(1, 1, 1, 0), Duration)
	tween.tween_property(GreyLayer, "visible", false, 0.0)

func tweenBox(ONorOFF : String, Duration : float):
	
	var tween = get_tree().create_tween()
	
	if ONorOFF == "ON":
		
		is_animating = true
		
		tween.tween_property(
			DialogueBoxButton, 
			"position", 
			Vector2(282, 433), 
			Duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		
		tween.connect("finished", Callable(self, "on_tween_on_finished"))
		
	elif ONorOFF == "OFF":
		
		DialogueManager.is_in_interface = false
		
		tween.tween_property(
			DialogueBoxButton, 
			"position", 
			Vector2(282, 657), 
			Duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		

func on_tween_on_finished():
	is_animating = false
	DialogueManager.is_in_interface = true


func spawnDialogue(Person : String, Message : String, Duration : float):
	
	self.visible = true
	
	PersonLabel.text = Person
	MessageLabel.text = Message
	
	MessageLabel.visible_ratio = 0.0
	
	tweenBox("ON", 0.5)
	showGreyOverlay(0.5)
	
	spawnTween = get_tree().create_tween().set_parallel()
	
	
	spawnTween.tween_interval(0.5)
	spawnTween.tween_property(MessageLabel, "visible_ratio", 1.0, Duration).from(0.0)

func despawnDialogue():
	DialogueManager.is_in_interface = false
	tweenBox("OFF", 0.5)
	hideGreyOverlay(0.5)
