# ============================================================= #
# HandItem_SCRIPT.gd [CLASS: HandItems]
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

@icon("res://Textures/Icons/Script Icons/32x32/object_hand.png")
class_name HandItems extends Resource

@export var ITEM_TYPE : String
@export_category("Orientation")
@export var mesh_position : Vector3
@export var mesh_rotation : Vector3
@export var mesh_scale : Vector3 = Vector3(1, 1, 1)
@export_category("Visual")
@export var model_path : String
@export_group("Sway")
@export var sway_min : Vector2 = Vector2(-20.0, -20.0)
@export var sway_max : Vector2 = Vector2(20.0, 20.0)
@export_range(0, 0.2, 0.01) var sway_speed_position : float = 0.07
@export_range(0, 0.2, 0.01) var sway_speed_rotation : float = 0.1
@export_range(0, 0.25, 0.01) var sway_amount_position : float = 0.1
@export_range(0, 50, 0.1) var sway_amount_rotation : float = 30.0
@export var idle_sway_adjustment : float = 10.0
@export var idle_sway_rotation_strength : float = 300.0
@export_range(0.1, 10.0, 0.1) var random_sway_amount : float = 5.0
@export_group("Bobbing")
@export var bob_speed : float = 5.0
@export var hbob_amount : float = 0.05
@export var vbob_amount : float = 0.05
@export_category("Metadata")
@export var damage_amount : float
