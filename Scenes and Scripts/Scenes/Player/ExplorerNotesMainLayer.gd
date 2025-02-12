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
		FocusedNoteImage.texture = load("res://Textures/Explorer Notes/" + str(ExplorerNotesManager.COLLECTED_NOTES[0]) +"_Sheet.png")
		if ExplorerNotesManager.COLLECTED_NOTES.size() >= 2:
			RightNoteImage.texture = load("res://Textures/Explorer Notes/" + str(ExplorerNotesManager.COLLECTED_NOTES[1]) +"_Sheet.png")
		else:
			RightNoteImage.texture = null
	else:
		RightNoteImage.texture = null
		FocusedNoteImage.texture = null
	
	LeftNoteImage.texture = null



func _on_right_arrow_btn_pressed() -> void:
	pass

func _on_left_arrow_btn_pressed() -> void:
	pass

func updateView():
	pass
