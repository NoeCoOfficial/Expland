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

var spawnTween
var isDisplayingText: bool = false

func _ready() -> void:
	self.mouse_filter = Control.MOUSE_FILTER_PASS
	self.visible = false
	Utils.set_center_offset($DialogueBox)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("LeftClick") and DialogueManager.is_in_interface:
		if isDisplayingText:
			print("Completing text display")
			completeTextDisplay()
		elif DialogueManager.finished_displaying_text:
			print("Despawning interface")
			despawnInterface()

func completeTextDisplay() -> void:
	if spawnTween:
		spawnTween.stop()
		spawnTween.kill()
	$DialogueBox/Message.visible_ratio = 1
	DialogueManager.finished_displaying_text = true
	isDisplayingText = false
	print("Text display completed")

func spawnInterfaceWithText(Person: String, Message: String, Duration: float) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	$GreyLayer.visible = true
	$GreyLayer.modulate = Color(1, 1, 1, 0)
	
	DialogueManager.is_in_interface = true
	self.visible = true
	
	$DialogueBox.scale = Vector2(0, 0)
	$DialogueBox.position = Vector2(282, 658)
	$DialogueBox/Person.text = Person
	$DialogueBox/Message.text = Message
	$DialogueBox/Message.visible_ratio = 0
	
	# Reset finished_displaying_text and isDisplayingText
	DialogueManager.finished_displaying_text = false
	isDisplayingText = true
	
	# Reinitialize spawnTween
	if spawnTween:
		spawnTween.stop()
		spawnTween.kill()
	spawnTween = get_tree().create_tween().set_parallel()
	
	spawnTween.connect("finished", Callable(self, "_on_text_display_finished"), 1)
	
	spawnTween.tween_property($DialogueBox, "scale", Vector2(1, 1), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	spawnTween.tween_property($DialogueBox, "position", Vector2(282, 434), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	spawnTween.tween_property($GreyLayer, "modulate", Color(1, 1, 1, 1), 0.5)
	
	spawnTween.set_parallel(false)
	spawnTween.tween_interval(0.5)
	spawnTween.tween_property($DialogueBox/Message, "visible_ratio", 1, Duration)
	
	
	await get_tree().create_timer(Duration).timeout
	DialogueManager.finished_displaying_text = true
	isDisplayingText = false
	print("Text display finished")

func _on_text_display_finished():
	DialogueManager.finished_displaying_text = true
	isDisplayingText = false

func despawnInterface() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	DialogueManager.is_in_interface = false
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($DialogueBox, "scale", Vector2(0, 0), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($DialogueBox, "position", Vector2(282, 658), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($GreyLayer, "modulate", Color(1, 1, 1, 0), 0.5)
	
	await get_tree().create_timer(0.5).timeout
	
	$DialogueBox/Message.visible_ratio = 0
	if spawnTween:
		spawnTween.stop()
		spawnTween.kill()
	$GreyLayer.visible = false
	print("Interface despawned")
