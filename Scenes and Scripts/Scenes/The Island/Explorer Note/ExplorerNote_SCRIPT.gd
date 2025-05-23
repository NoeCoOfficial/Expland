# ============================================================= #
# ExplorerNote_SCRIPT.gd
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

@tool
@icon("res://Textures/Icons/Script Icons/32x32/script_text.png")
extends Node3D

@export var NoteID : int
@export var ImageAlbedo : Texture2D
@export var ImageNormal : Texture2D
@export var ImageOrm : Texture2D
@export var ImageEmission : Texture2D
@export var DecalRotation_Degrees : Vector3
@export var DecalSize : Vector3 = Vector3(2, 2, 2)
@export var DecalLowerFade : float = 0.3
@export var NailRotation_Degrees : Vector3
@export var ShowNail : bool = true

@export var DecalNode : Decal
@export var Nail : Node
@export var CollisionShape : CollisionShape3D

func _ready() -> void:
	if !Engine.is_editor_hint():
		SignalBus.remove_explorer_notes.connect(initRemoveNote)

func _process(_delta: float) -> void:
	DecalNode.texture_albedo = ImageAlbedo
	DecalNode.texture_normal = ImageNormal
	DecalNode.texture_orm = ImageOrm
	DecalNode.texture_emission = ImageEmission
	
	DecalNode.size = DecalSize
	DecalNode.lower_fade = DecalLowerFade
	DecalNode.rotation_degrees = DecalRotation_Degrees
	Nail.visible = ShowNail
	Nail.rotation_degrees = NailRotation_Degrees

func getID():
	return NoteID

func removeNote():
	self.visible = false
	CollisionShape.disabled = true

func initRemoveNote():
	print("NoteID: ", NoteID, " (Type: ", typeof(NoteID), ")")
	print("Collected Notes: ", str(ExplorerNotesManager.COLLECTED_NOTES), " (Type: ", typeof(ExplorerNotesManager.COLLECTED_NOTES), ")")
	
	for collected_note in ExplorerNotesManager.COLLECTED_NOTES:
		print("Collected Note: ", collected_note, " (Type: ", typeof(collected_note), ")")
	
	if float(NoteID) in ExplorerNotesManager.COLLECTED_NOTES:
		print("NoteID found in collected notes.")
		self.visible = false
		CollisionShape.disabled = true
	else:
		print("NoteID not found in collected notes.")

func set_disabled_collision(value):
	CollisionShape.disabled = value

func _on_remove_note_timer_timeout() -> void:
	initRemoveNote()
