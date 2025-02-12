# ============================================================= #
# ExplorerNotesMainLayer.gd
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

extends Control

@export var RightNoteImage : TextureRect
@export var LeftNoteImage : TextureRect
@export var FocusedNoteImage : TextureRect

func _ready() -> void:
	SignalBus.populate_explorer_note_ui.connect(populateImages)

func populateImages():
	if !ExplorerNotesManager.COLLECTED_NOTES.is_empty():
		print("Explorer Notes: " + str(ExplorerNotesManager.COLLECTED_NOTES))
		FocusedNoteImage.texture = load("res://Textures/Explorer Notes/" + str(ExplorerNotesManager.COLLECTED_NOTES[0]) + "_Sheet.png")
		
		ExplorerNotesManager.UI_CurrentlyFocusedIndex = 0
		ExplorerNotesManager.UI_CurrentlyFocusedID = ExplorerNotesManager.COLLECTED_NOTES[ExplorerNotesManager.UI_CurrentlyFocusedIndex]
		
		if ExplorerNotesManager.COLLECTED_NOTES.size() >= 2:
			ExplorerNotesManager.UI_CurrentRightIndex = 1
			ExplorerNotesManager.UI_CurrentRightID = ExplorerNotesManager.COLLECTED_NOTES[ExplorerNotesManager.UI_CurrentRightIndex]
			RightNoteImage.texture = load("res://Textures/Explorer Notes/" + str(ExplorerNotesManager.COLLECTED_NOTES[1]) + "_Sheet.png")
		else:
			RightNoteImage.texture = null
	else:
		RightNoteImage.texture = null
		FocusedNoteImage.texture = null
	LeftNoteImage.texture = null

func _on_right_arrow_btn_pressed() -> void:
	if ExplorerNotesManager.UI_CurrentRightIndex != null:
		ExplorerNotesManager.UI_CurrentLeftIndex = ExplorerNotesManager.UI_CurrentlyFocusedIndex
		ExplorerNotesManager.UI_CurrentLeftID = ExplorerNotesManager.UI_CurrentlyFocusedID
		LeftNoteImage.texture = load("res://Textures/Explorer Notes/" + str(ExplorerNotesManager.UI_CurrentLeftID) + "_Sheet.png")
		
		ExplorerNotesManager.UI_CurrentlyFocusedIndex = ExplorerNotesManager.UI_CurrentRightIndex
		ExplorerNotesManager.UI_CurrentlyFocusedID = ExplorerNotesManager.UI_CurrentRightID
		FocusedNoteImage.texture = load("res://Textures/Explorer Notes/" + str(ExplorerNotesManager.UI_CurrentlyFocusedID) + "_Sheet.png")
		
		if ExplorerNotesManager.UI_CurrentRightIndex == ExplorerNotesManager.COLLECTED_NOTES.size() - 1:
			ExplorerNotesManager.UI_CurrentRightIndex = null
			ExplorerNotesManager.UI_CurrentRightID = null
			RightNoteImage.texture = null
		else:
			ExplorerNotesManager.UI_CurrentRightIndex += 1
			ExplorerNotesManager.UI_CurrentRightID = ExplorerNotesManager.COLLECTED_NOTES[ExplorerNotesManager.UI_CurrentRightIndex]
			RightNoteImage.texture = load("res://Textures/Explorer Notes/" + str(ExplorerNotesManager.UI_CurrentRightID) + "_Sheet.png")

func _on_left_arrow_btn_pressed() -> void:
	if ExplorerNotesManager.UI_CurrentLeftIndex != null:
		ExplorerNotesManager.UI_CurrentRightIndex = ExplorerNotesManager.UI_CurrentlyFocusedIndex
		ExplorerNotesManager.UI_CurrentRightID = ExplorerNotesManager.UI_CurrentlyFocusedID
		RightNoteImage.texture = load("res://Textures/Explorer Notes/" + str(ExplorerNotesManager.UI_CurrentRightID) + "_Sheet.png")
		
		ExplorerNotesManager.UI_CurrentlyFocusedIndex = ExplorerNotesManager.UI_CurrentLeftIndex
		ExplorerNotesManager.UI_CurrentlyFocusedID = ExplorerNotesManager.UI_CurrentLeftID
		FocusedNoteImage.texture = load("res://Textures/Explorer Notes/" + str(ExplorerNotesManager.UI_CurrentlyFocusedID) + "_Sheet.png")
		
		if ExplorerNotesManager.UI_CurrentLeftIndex == 0:
			ExplorerNotesManager.UI_CurrentLeftIndex = null
			ExplorerNotesManager.UI_CurrentLeftID = null
			LeftNoteImage.texture = null
		else:
			ExplorerNotesManager.UI_CurrentLeftIndex -= 1
			ExplorerNotesManager.UI_CurrentLeftID = ExplorerNotesManager.COLLECTED_NOTES[ExplorerNotesManager.UI_CurrentLeftIndex]
			LeftNoteImage.texture = load("res://Textures/Explorer Notes/" + str(ExplorerNotesManager.UI_CurrentLeftID) + "_Sheet.png")
