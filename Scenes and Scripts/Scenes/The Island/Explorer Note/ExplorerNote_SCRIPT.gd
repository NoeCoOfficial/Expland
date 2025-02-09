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


func _ready() -> void:
	SignalBus.remove_explorer_notes.connect(initRemoveNote)


func _process(_delta: float) -> void:
	$Decal.texture_albedo = ImageAlbedo
	$Decal.texture_normal = ImageNormal
	$Decal.texture_orm = ImageOrm
	$Decal.texture_emission = ImageEmission

	$Decal.size = DecalSize
	$Decal.lower_fade = DecalLowerFade
	$Decal.rotation_degrees = DecalRotation_Degrees
	$RustyNail.visible = ShowNail
	$RustyNail.rotation_degrees = NailRotation_Degrees

func getID():
	return NoteID

func initRemoveNote():
	self.visible = false
	$StaticBody3D/CollisionShape3D.disabled = true

func set_disabled_collision(value):
	$StaticBody3D/CollisionShape3D.disabled = value


func _on_remove_note_timer_timeout() -> void:
	if NoteID in ExplorerNotesManager.COLLECTED_NOTES:
		initRemoveNote()
	else:
		print("skibidi toulet wefweewfewfwefwe")
		print(str(ExplorerNotesManager.COLLECTED_NOTES))
