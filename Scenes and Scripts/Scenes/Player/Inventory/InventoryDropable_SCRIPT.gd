# ============================================================= #
# InventoryDropable_SCRIPT.gd
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

@icon("res://Textures/Icons/Script Icons/32x32/inventory.png")
extends Node2D

@export var ITEM_TYPE : String
@export var ITEM_TYPE_Label : Label
@export var ITEM_Sprite : Sprite2D

@export var is_in_chest_slot = false
@export var is_workshop_dropable = false
@export var is_workshop_output_dropable = false
@export var is_hotbar_dropable = false

@export var mouse_over_timer : Timer
@export var populated_on_startup_timer : Timer

var EffectNotificationScene = preload("uid://jajswfbkaut2")

var draggable = false
var is_inside_slot = false

var is_inside_hotbar_slot = false

var body_ref
var initialPos: Vector2
var offset: Vector2
var slot_inside = null
var SNAP_TIME = 0.0
var debounce_timer = 0.2
var can_create_pickup = true
var is_hovering_over = false
var can_quick_switch = false
var can_quick_drop = false

func _ready():
	self.name = "Dropable"
	self.z_index = 0
	
	ITEM_TYPE_Label.text = ITEM_TYPE.capitalize()
	
	if "REDFLOWER" in ITEM_TYPE:
		ITEM_TYPE_Label.text = "Red Flower"
	elif "BLUEFLOWER" in ITEM_TYPE:
		ITEM_TYPE_Label.text = "Blue Flower"
	elif "BLANKFLOWER" in ITEM_TYPE:
		ITEM_TYPE_Label.text = "Blank Flower"
	elif "PINKFLOWER" in ITEM_TYPE:
		ITEM_TYPE_Label.text = "Pink Flower"
	elif "YELLOWFLOWER" in ITEM_TYPE:
		ITEM_TYPE_Label.text = "Yellow Flower"
	
	elif "WOODPLANK" in ITEM_TYPE:
		ITEM_TYPE_Label.text = "Wood Plank"
	
	elif "EFFICIENCYPOTION" in ITEM_TYPE:
		ITEM_TYPE_Label.text = "Efficiency Potion"
	elif "HASTEPOTION" in ITEM_TYPE:
		ITEM_TYPE_Label.text = "Haste Potion"
	elif "HEALTHPOTION" in ITEM_TYPE:
		ITEM_TYPE_Label.text = "Health Potion"
	elif "LUCKPOTION" in ITEM_TYPE:
		ITEM_TYPE_Label.text = "Luck Potion"
	elif "NIGHTVISIONPOTION" in ITEM_TYPE:
		ITEM_TYPE_Label.text = "Night Vision Potion"
	elif "REGENERATINGPOTION" in ITEM_TYPE:
		ITEM_TYPE_Label.text = "Regenerating Potion"
	elif "STAMINAPOTION" in ITEM_TYPE:
		ITEM_TYPE_Label.text = "Stamina Potion"
	elif "STRENGTHPOTION" in ITEM_TYPE:
		ITEM_TYPE_Label.text = "Strength Potion"
	
	if ITEM_TYPE != "":
		var OBJ_TEXTURE: Texture2D = load("res://Textures/Inventory/" + ITEM_TYPE + ".png")
		if OBJ_TEXTURE == null:
			print("Failed to load texture: res://Textures/Inventory/" + ITEM_TYPE + ".png")
		else:
			ITEM_Sprite.texture = OBJ_TEXTURE
	
	mouse_over_timer.connect("timeout", Callable(self, "_on_mouse_over_timeout"))
	
	if not mouse_over_timer.is_inside_tree():
		add_child(mouse_over_timer)

func _process(delta):
	pass

func _input(_event: InputEvent) -> void:
	pass
