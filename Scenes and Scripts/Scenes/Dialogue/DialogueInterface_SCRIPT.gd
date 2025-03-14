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

signal FinishedDialogue(StoryModeID : int)

@export var GreyLayer : ColorRect
@export var DialogueBoxButton : Button
@export var PersonLabel : Label
@export var MessageLabel : Label
@export var SideArrowIcon : TextureRect

var is_animating = false
var spawnTween

######################################
# On startup
######################################

func _ready() -> void:
	
	self.visible = false
	
	tweenSideArrow()
	
	GreyLayer.visible = false
	GreyLayer.modulate = Color(1, 1, 1, 0)
	
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE

######################################
# Process
######################################

func _process(_delta: float) -> void:
	if MessageLabel.visible_ratio != 1:
		SideArrowIcon.visible = false
	else:
		SideArrowIcon.visible = true

######################################
# Input
######################################

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Dialogue") and DialogueManager.is_in_interface and MessageLabel.visible_ratio == 1:
		DialogueManager.showNextMessage()
	if Input.is_action_just_pressed("Dialogue") and DialogueManager.is_in_interface and MessageLabel.visible_ratio < 1 and MessageLabel.visible_ratio > 0:
		spawnTween.stop()
		MessageLabel.visible_ratio = 1

######################################
# Show/Hide Grey overlay
######################################

func showGreyOverlay(Duration : float):
	GreyLayer.visible = true
	
	if PlayerSettingsData.quickAnimations:
		GreyLayer.modulate = Color(1, 1, 1, 1)
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(GreyLayer, "modulate", Color(1, 1, 1, 1), Duration)

func hideGreyOverlay(Duration : float):
	if PlayerSettingsData.quickAnimations:
		GreyLayer.modulate = Color(1, 1, 1, 0)
		GreyLayer.visible = false
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(GreyLayer, "modulate", Color(1, 1, 1, 0), Duration)
		tween.tween_property(GreyLayer, "visible", false, 0.0)

######################################
# Tweening dialogue box
######################################

func tweenSideArrow():
	var tween = get_tree().create_tween()
	tween.tween_property(SideArrowIcon, "position", Vector2(580, 145), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(SideArrowIcon, "position", Vector2(580, 153), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.connect("finished", Callable(self, "onSideArrowAnimFinished"))

func onSideArrowAnimFinished():
	tweenSideArrow()

func tweenBox(ONorOFF : String, Duration : float):
	if PlayerSettingsData.quickAnimations:
		if ONorOFF == "ON":
			DialogueBoxButton.position = Vector2(259.12, 433)
			is_animating = false
			DialogueManager.is_in_interface = true
		elif ONorOFF == "OFF":
			DialogueBoxButton.position = Vector2(259.12, 656)
			DialogueManager.is_in_interface = false
	else:
		var tween = get_tree().create_tween()
		if ONorOFF == "ON":
			is_animating = true
			tween.tween_property(
				DialogueBoxButton, 
				"position", 
				Vector2(259.12, 433), 
				Duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
			tween.connect("finished", Callable(self, "on_tween_on_finished"))
		elif ONorOFF == "OFF":
			DialogueManager.is_in_interface = false
			tween.tween_property(
				DialogueBoxButton, 
				"position", 
				Vector2(259.12, 656), 
				Duration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)

func on_tween_on_finished():
	is_animating = false
	DialogueManager.is_in_interface = true

######################################
# Spawn and despawn dialogue
######################################

func spawnDialogue(Person : String, Message : String, Duration : float):
	
	DialogueManager.is_in_absolute_interface = true
	
	self.visible = true
	
	PersonLabel.text = Person
	
	MessageLabel.text = Message
	MessageLabel.visible_ratio = 0.0
	
	tweenBox("ON", 0.5)
	showGreyOverlay(0.5)
	
	
	await get_tree().create_timer(0.5).timeout
	spawnTween = get_tree().create_tween().set_parallel()
	spawnTween.tween_property(MessageLabel, "visible_ratio", 1.0, Duration).from(0.0)

func despawnDialogue():
	FinishedDialogue.emit(DialogueManager.Current_StoryModeID)
	DialogueManager.is_in_absolute_interface = false
	DialogueManager.is_in_interface = false
	DialogueManager.Current_StoryModeID = null
	
	tweenBox("OFF", 0.5)
	hideGreyOverlay(0.5)
