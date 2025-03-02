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
	
	# Ensure the timer is added to the scene tree
	if not mouse_over_timer.is_inside_tree():
		add_child(mouse_over_timer)

func _process(delta):
	if InventoryManager.is_dragging:
		PlayerManager.MINIMAL_ALERT_PLAYER.hide_minimal_alert(0.1)
	
	if debounce_timer > 0:
		debounce_timer -= delta
	else:
		can_create_pickup = true
	
	if draggable:
		if Input.is_action_just_pressed("LeftClick"):
			if mouse_over_timer.time_left == 0:
				initialPos = global_position
				InventoryManager.is_dragging = true
				if is_in_chest_slot or is_workshop_dropable or is_workshop_output_dropable:
					top_level = true
				self.z_index = 10
				InventoryManager.item_ref = ITEM_TYPE
				
				
		if Input.is_action_pressed("LeftClick") and InventoryManager.is_dragging:
			global_position = get_global_mouse_position()
		
		elif Input.is_action_just_released("LeftClick"):
			
			if InventoryManager.is_inside_boundary and can_create_pickup:
				InventoryManager.is_dragging = false
				
				if slot_inside and slot_inside.has_method("set_populated"):
					slot_inside.set_populated(false)
				
				can_create_pickup = false
				debounce_timer = 0.2
				InventoryManager.create_pickup_object()
				
				queue_free()
				
			else:
				
				InventoryManager.is_dragging = false
				self.z_index = 0
				if is_inside_dropable and !InventoryManager.is_inside_checker:
					if body_ref == slot_inside:
						# If the draggable is placed back into its current slot, do nothing
						global_position = body_ref.global_position
						
						if is_in_chest_slot:
							is_in_chest_slot = true
							self.queue_free()
							InventoryManager.spawn_inventory_dropable(slot_inside.global_position, ITEM_TYPE, slot_inside, true)
							top_level = false
						
						elif is_workshop_dropable:
							is_workshop_dropable = true
							self.queue_free()
							InventoryManager.spawn_workshop_dropable(slot_inside.global_position, ITEM_TYPE, slot_inside)
							top_level = false
							
						elif is_workshop_output_dropable:
							is_workshop_output_dropable = true
							self.queue_free()
							InventoryManager.spawn_workbench_output_dropable(ITEM_TYPE)
							top_level = false
						
					else:
						if body_ref.has_method("is_populated") and body_ref.is_populated():
							# If the slot is already populated, snap back to the original position
							global_position = initialPos
							
							if is_in_chest_slot:
								is_in_chest_slot = true
								InventoryManager.spawn_inventory_dropable(slot_inside.global_position, ITEM_TYPE, slot_inside, true)
								top_level = false
								queue_free()
							
							elif is_workshop_dropable:
								is_workshop_dropable = true
								InventoryManager.spawn_workshop_dropable(slot_inside.global_position, ITEM_TYPE, slot_inside)
								top_level = false
								queue_free()
								
							elif is_workshop_output_dropable:
								is_workshop_output_dropable = true
								InventoryManager.spawn_workbench_output_dropable(ITEM_TYPE)
								top_level = false
								queue_free()
							
						else:
							# If the slot is not populated, snap to the new slot
							global_position = body_ref.global_position
							if body_ref.has_method("set_populated"):
								body_ref.set_populated(true)
								
								if slot_inside != null:
									if slot_inside.has_method("set_populated"):
										slot_inside.set_populated(false)
								
								if is_workshop_dropable:
									CraftingManager.unbindCraftingItem(int(String(slot_inside.name)[-1]) - 1)
								
								slot_inside = body_ref
								
								if body_ref.get_is_chest_slot(): # If the slot is a chest slot
									is_in_chest_slot = true
									InventoryManager.spawn_inventory_dropable(slot_inside.global_position, ITEM_TYPE, slot_inside, true)
									top_level = false
									queue_free()
								
								elif body_ref.get_is_workbench_slot(): # If the slot is a workbench slot
									is_workshop_dropable = true
									InventoryManager.spawn_workshop_dropable(slot_inside.global_position, ITEM_TYPE, slot_inside)
									top_level = false
									queue_free()
								
								elif body_ref.get_is_workbench_output_slot(): # If the slot is a workbench output slot
									is_workshop_dropable = true
									InventoryManager.spawn_workbench_output_dropable(ITEM_TYPE)
									top_level = false
									queue_free()
								
								else: # If the slot is a pocket slot
									
									if is_in_chest_slot: # If the draggable was in a chest slot
										is_in_chest_slot = false
										InventoryManager.spawn_inventory_dropable(slot_inside.global_position, ITEM_TYPE, slot_inside, false)
										top_level = false
										queue_free()
									
									elif is_workshop_dropable: # If the draggable was in a workshop slot
										is_workshop_dropable = false
										CraftingManager.unbindCraftingItem(int(String(slot_inside.name)[-1]) - 1)
										InventoryManager.spawn_inventory_dropable(slot_inside.global_position, ITEM_TYPE, slot_inside, false)
										top_level = false
										queue_free()
									
									elif is_workshop_output_dropable: # If the draggable was in a workshop output slot
										is_workshop_output_dropable = false
										InventoryManager.spawn_inventory_dropable(slot_inside.global_position, ITEM_TYPE, slot_inside, false)
										top_level = false
										queue_free()
									
									else: # If the draggable was in a pocket slot
										is_workshop_output_dropable = false
										is_workshop_dropable = false
										is_in_chest_slot = false
									
							else:
								print("{LOCAL} [InventoryDropable_SCRIPT.gd] " + body_ref + " does not have method: set_populated()")
				else:
					global_position = initialPos
					
					if is_in_chest_slot:
						is_in_chest_slot = true
						InventoryManager.spawn_inventory_dropable(slot_inside.global_position, ITEM_TYPE, slot_inside, true)
						top_level = false
						PlayerManager.MINIMAL_ALERT_PLAYER.hide_minimal_alert(0.1)
						queue_free()
					
					elif is_workshop_dropable:
						is_workshop_dropable = true
						InventoryManager.spawn_workshop_dropable(slot_inside.global_position, ITEM_TYPE, slot_inside)
						top_level = false
						PlayerManager.MINIMAL_ALERT_PLAYER.hide_minimal_alert(0.1)
						queue_free()
						
					elif is_workshop_output_dropable:
						is_workshop_output_dropable = true
						InventoryManager.spawn_workbench_output_dropable(ITEM_TYPE)
						top_level = false
						PlayerManager.MINIMAL_ALERT_PLAYER.hide_minimal_alert(0.1)
						queue_free()
			
			if mouse_over_timer.is_inside_tree():                          
				mouse_over_timer.start() # Restart the timer when the item is placed down

func _input(_event: InputEvent) -> void:
	# Quick Dropping
	if Input.is_action_just_pressed("Inventory_QuickDrop"):
		if can_quick_drop and !InventoryManager.is_dragging:
			InventoryManager.item_ref = ITEM_TYPE
			InventoryManager.create_pickup_object()
			slot_inside.set_populated(false)
			queue_free()
		
	# Quick switching
	if Input.is_action_just_pressed("Inventory_QuickSwitch"):
		if can_quick_switch and !InventoryManager.is_dragging:
			if InventoryManager.in_chest_interface or InventoryManager.is_in_workbench_interface:
				# If it's a chest dropable, we want to switch to a pocket slot
				if is_in_chest_slot:
					
					var free_slot = null
					
					# Get the free slot from pocket slots (9)
					free_slot = InventoryManager.get_free_slot(InventoryManager.POCKET_SLOTS)
					
					if free_slot != null and !free_slot.is_populated():
						free_slot.set_populated(true)
						InventoryManager.spawn_inventory_dropable(free_slot.global_position, ITEM_TYPE, free_slot, false)
						
						slot_inside.set_populated(false)
						InventoryManager.is_dragging = false
						queue_free()
					else:
						InventoryManager.is_dragging = false
				
				# If it's a workshop dropable, we want to switch to a pocket slot
				elif is_workshop_dropable:
					
					var free_slot = null
					
					# Get the free slot from pocket slots (9)
					free_slot = InventoryManager.get_free_slot(InventoryManager.POCKET_SLOTS)
					
					if free_slot != null and !free_slot.is_populated():
						free_slot.set_populated(true)
						
						CraftingManager.unbindCraftingItem(int(String(slot_inside.name)[-1]) - 1)
						
						InventoryManager.spawn_inventory_dropable(free_slot.global_position, ITEM_TYPE, free_slot, false)
						
						slot_inside.set_populated(false)
						InventoryManager.is_dragging = false
						queue_free()
						
					else:
						InventoryManager.is_dragging = false
				
				# If it's a workshop output dropable, we want to switch to a pocket slot
				elif is_workshop_output_dropable:
					var free_slot = null
					
					# Get the free slot from pocket slots (9)
					free_slot = InventoryManager.get_free_slot(InventoryManager.POCKET_SLOTS)
					
					if free_slot != null and !free_slot.is_populated():
						free_slot.set_populated(true)
						
						InventoryManager.spawn_inventory_dropable(free_slot.global_position, ITEM_TYPE, free_slot, false)
						
						slot_inside.set_populated(false)
						InventoryManager.is_dragging = false
						queue_free()
						
					else:
						InventoryManager.is_dragging = false
				
				# If it's a pocket dropable, we want to switch to either a chest or workshop slot
				else:
					if InventoryManager.in_chest_interface:
						var free_slot = null
						
						# Get the free slot from chest slots (25)
						free_slot = InventoryManager.get_free_slot(InventoryManager.CHEST_SLOTS)
						
						if free_slot != null and !free_slot.is_populated():
							free_slot.set_populated(true)
							InventoryManager.spawn_inventory_dropable(free_slot.global_position, ITEM_TYPE, free_slot, true)
							
							slot_inside.set_populated(false)
							InventoryManager.is_dragging = false
							queue_free()
						else:
							InventoryManager.is_dragging = false
						
					elif InventoryManager.is_in_workbench_interface:
						
						var free_slot = null
						
						# Get the free slot from workshop slots (5)
						free_slot = InventoryManager.get_free_slot(InventoryManager.WORKSHOP_SLOTS)
						
						if free_slot != null and !free_slot.is_populated():
							free_slot.set_populated(true)
							InventoryManager.spawn_workshop_dropable(free_slot.global_position, ITEM_TYPE, free_slot)
							
							CraftingManager.bindCraftingItem(ITEM_TYPE, int(String(free_slot.name)[-1]) - 1)
							
							slot_inside.set_populated(false)
							InventoryManager.is_dragging = false
							queue_free()
						else:
							InventoryManager.is_dragging = false
					
				InventoryManager.is_dragging = false
				debounce_timer = 0.2
	
	# Consuming items
	if Input.is_action_just_pressed("RightClick") and debounce_timer <= 0:
		if InventoryManager.inventory_open and !InventoryManager.is_creating_pickup and is_hovering_over and !InventoryManager.is_dragging:
				# Right clicked on a consumable item (see InventoryManager.gd for contents)
				if ITEM_TYPE in InventoryManager.CONSUMABLE_ITEMS:
					PlayerManager.MINIMAL_ALERT_PLAYER.hide_minimal_alert(0.1)
					
					if ITEM_TYPE in InventoryManager.FOOD_ITEMS:
						
						var value = InventoryManager.FOOD_ITEMS[ITEM_TYPE]
						PlayerManager.eat(value)
						InventoryManager.is_dragging = false
						slot_inside.set_populated(false)
						self.queue_free()
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
	can_quick_switch = true
	can_quick_drop = true

	if !InventoryManager.is_dragging:
		is_hovering_over = true
		mouse_over_timer.start()
		scale = Vector2(1.05, 1.05)
		
	if InventoryManager.inventory_open and !InventoryManager.is_creating_pickup and !InventoryManager.is_dragging:
		if ITEM_TYPE in InventoryManager.CONSUMABLE_ITEMS:
			PlayerManager.MINIMAL_ALERT_PLAYER.show_minimal_alert(0.1, "Right click to consume item")

func _on_area_2d_mouse_exited():
	can_quick_switch = false
	can_quick_drop = false

	if !InventoryManager.is_dragging:
		is_hovering_over = false
		mouse_over_timer.stop()
		draggable = false
		scale = Vector2(1.0, 1.0)
		
		if ITEM_TYPE in InventoryManager.CONSUMABLE_ITEMS:
			PlayerManager.MINIMAL_ALERT_PLAYER.hide_minimal_alert(0.1)

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


func set_is_in_chest_slot(value : bool):
	is_in_chest_slot = value

func get_is_in_chest_slot():
	return is_in_chest_slot


func set_is_workshop_dropable(value : bool):
	is_workshop_dropable = value

func get_is_workshop_dropable():
	return is_workshop_dropable


func set_is_workshop_output_dropable(value : bool):
	is_workshop_output_dropable = value
	body_ref = InventoryManager.WORKSHOP_OUTPUT_SLOT
	is_inside_dropable = true

func get_is_workshop_output_dropable():
	return is_workshop_output_dropable

func _on_tree_exited() -> void:
	mouse_over_timer.disconnect("timeout", Callable(self, "_on_mouse_over_timeout"))
