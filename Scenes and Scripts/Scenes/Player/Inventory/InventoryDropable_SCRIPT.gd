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

@export var mouse_over_timer : Timer
@export var populated_on_startup_timer : Timer

var draggable = false
var is_inside_dropable = false
var body_ref
var initialPos: Vector2
var offset: Vector2
var slot_inside = null
var SNAP_TIME = 0.0
var debounce_timer = 0.2
var can_create_pickup = true
var is_hovering_over = false

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
	
	# Ensure the timer is added to the scene tree
	if not mouse_over_timer.is_inside_tree():
		add_child(mouse_over_timer)

func _process(delta):
	if debounce_timer > 0:
		debounce_timer -= delta
	else:
		can_create_pickup = true
		
	if draggable:
		if Input.is_action_just_pressed("LeftClick"):
			if mouse_over_timer.time_left == 0:
				initialPos = global_position
				InventoryManager.is_dragging = true
				self.z_index = 10
				InventoryManager.item_ref = ITEM_TYPE
		if Input.is_action_pressed("LeftClick") and InventoryManager.is_dragging:
			global_position = get_global_mouse_position()
		
		elif Input.is_action_just_released("LeftClick"):
			
			if InventoryManager.is_inside_boundary and can_create_pickup:
				InventoryManager.is_dragging = false
				
				if slot_inside and slot_inside.has_method("set_populated"):
					slot_inside.set_populated(false)
				
				var PARENT = self.get_parent()
				PARENT.remove_child(self)
				can_create_pickup = false
				debounce_timer = 0.2
				InventoryManager.create_pickup_object()
				
			else:
				
				InventoryManager.is_dragging = false
				self.z_index = 0
				var tween = get_tree().create_tween()
				if is_inside_dropable and !InventoryManager.is_inside_checker:
					if body_ref == slot_inside:
						# If the draggable is placed back into its current slot, do nothing
						tween.tween_property(self, "position", body_ref.position, SNAP_TIME)
					else:
						if body_ref.has_method("is_populated") and body_ref.is_populated():
							# If the slot is already populated, snap back to the original position
							tween.tween_property(self, "global_position", initialPos, SNAP_TIME)
						else:
							tween.tween_property(self, "position", body_ref.position, SNAP_TIME)
							if body_ref.has_method("set_populated"):
								body_ref.set_populated(true)
								if slot_inside != null:
									if slot_inside.has_method("set_populated"):
										slot_inside.set_populated(false)
								slot_inside = body_ref
							else:
								print("{LOCAL} [InventoryDropable_SCRIPT.gd] " + body_ref + " does not have method: set_populated()")
				else:
					tween.tween_property(self, "global_position", initialPos, SNAP_TIME)
			
			if mouse_over_timer.is_inside_tree():                          
				mouse_over_timer.start() # Restart the timer when the item is placed down

func _input(_event: InputEvent) -> void:
	var minimal_alert = get_node("/root/World/Player//Head/Camera3D/MinimalAlertLayer/MinimalAlert")
	
	if Input.is_action_just_pressed("RightClick") and debounce_timer <= 0:
		
		if InventoryManager.inventory_open and !InventoryManager.is_creating_pickup and is_hovering_over:
			
			if ITEM_TYPE != InventoryData.HAND_ITEM_TYPE:
				
				# Right clicked on a handheld item (see InventoryManager.gd for contents)
				if ITEM_TYPE in InventoryManager.HANDHELD_ITEMS:
					if PlayerManager.PLAYER.get_hand_debounce_time_left() <= 0.0:
						minimal_alert.hide_minimal_alert(0.1)
						slot_inside.set_populated(false)
						InventoryManager.set_hand_item(self, ITEM_TYPE)
						
						PlayerManager.PLAYER.start_hand_debounce_timer()
					
				# Right clicked on a consumable item (see InventoryManager.gd for contents)
				if ITEM_TYPE in InventoryManager.CONSUMABLE_ITEMS:
					minimal_alert.hide_minimal_alert(0.1)
					
					if ITEM_TYPE in InventoryManager.FOOD_ITEMS:
						
						var value = InventoryManager.FOOD_ITEMS[ITEM_TYPE]
						PlayerManager.eat(value)
						
						self.queue_free()
						slot_inside.set_populated(false)
						
					
					debounce_timer = 0.2

func _on_area_2d_body_entered(body):
	if body.is_in_group("slot") and !InventoryManager.is_inside_checker:  
		if populated_on_startup_timer.time_left > 0.0:
			slot_inside = body
		is_inside_dropable = true
		
		body_ref = body

func _on_area_2d_body_exited(body):
	if body.is_in_group("slot"):
		is_inside_dropable = false

func _on_area_2d_mouse_entered():
	
	if !InventoryManager.is_dragging:
		is_hovering_over = true
		mouse_over_timer.start()
		scale = Vector2(1.05, 1.05)
		
	if InventoryManager.inventory_open and !InventoryManager.is_creating_pickup:
		
		if ITEM_TYPE in InventoryManager.HANDHELD_ITEMS:
			var minimal_alert = get_node("/root/World/Player//Head/Camera3D/MinimalAlertLayer/MinimalAlert")
			minimal_alert.show_minimal_alert(0.1, "Right click to hold item")
		
		if ITEM_TYPE in InventoryManager.CONSUMABLE_ITEMS:
			var minimal_alert = get_node("/root/World/Player//Head/Camera3D/MinimalAlertLayer/MinimalAlert")
			minimal_alert.show_minimal_alert(0.1, "Right click to consume item")

func _on_area_2d_mouse_exited():
	if !InventoryManager.is_dragging:
		is_hovering_over = false
		mouse_over_timer.stop()
		draggable = false
		scale = Vector2(1.0, 1.0)
		
		# Dunno why I have to do it like this but hey
		# I don't wanna risk anything bro
		
		if ITEM_TYPE in InventoryManager.HANDHELD_ITEMS:
			var minimal_alert = get_node("/root/World/Player//Head/Camera3D/MinimalAlertLayer/MinimalAlert")
			minimal_alert.hide_minimal_alert(0.1)
		
		if ITEM_TYPE in InventoryManager.CONSUMABLE_ITEMS:
			var minimal_alert = get_node("/root/World/Player//Head/Camera3D/MinimalAlertLayer/MinimalAlert")
			minimal_alert.hide_minimal_alert(0.1)

func _on_mouse_over_timeout():
	draggable = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("draggable"):
		InventoryManager.is_inside_checker = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("draggable"):
		InventoryManager.is_inside_checker = false

func set_ITEM_TYPE(ITEM_TYPE_TEMP : String):
	ITEM_TYPE = ITEM_TYPE_TEMP
	ITEM_TYPE_Label.text = ITEM_TYPE.capitalize()
	
	var OBJ_TEXTURE: Texture2D = load("res://Textures/Inventory/" + ITEM_TYPE + ".png")
	if OBJ_TEXTURE == null:
		print("Failed to load texture: res://Textures/Inventory/" + ITEM_TYPE + ".png")
	else:
		ITEM_Sprite.texture = OBJ_TEXTURE

func get_ITEM_TYPE():
	return ITEM_TYPE

func get_slot_inside():
	return slot_inside

func set_slot_inside(slot):
	slot_inside = slot
