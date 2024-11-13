# ============================================================= #
# InventoryDropable_SCRIPT.gd
# ============================================================= #
#                       COPYRIGHT NOTICE                        #
#                           Noe Co.                             #
#                   2024 - All Rights Reserved                  #
#                                                               #
#                         MIT License                           #
#                                                               #
# Permission is hereby granted, free of charge, to any          #
# person obtaining a copy of this software and associated       #
# documentation files (the "Software"), to deal in the          #
# Software without restriction, including without limitation    #
# the rights to use, copy, modify, merge, publish, distribute,  #
# sublicense, and/or sell copies of the Software, and to        #
# permit persons to whom the Software is furnished to do so,    #
# subject to the following conditions:                          #
#                                                               #
# 1. The above copyright notice and this permission notice      #
#    shall be included in all copies or substantial portions    #
#    of the Software.                                           #
#                                                               #
# 2. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF      #
#    ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED    #
#    TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A        #
#    PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL  #
#    THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,  #
#    DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF        #
#    CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN    #
#    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER           #
#    DEALINGS IN THE SOFTWARE.                                  #
#                                                               #
#                   For inquiries, contact:                     #
#                  noeco.official@gmail.com                     #
# ============================================================= #

extends Node2D


var draggable = false
var is_inside_dropable = false
var body_ref
var initialPos: Vector2
var offset: Vector2
var slot_inside = null
@export var ITEM_TYPE: String ## The type of the item that the Sprite2D is holding.
var SNAP_TIME = 0.0
var debounce_timer = 0.2 # Debounce time in seconds
var can_create_pickup = true

@onready var mouse_over_timer = $MouseOverTimer

func _ready():
	self.z_index = 0
	$ITEM_TYPE.text = ITEM_TYPE.capitalize()
	if "REDFLOWER" in ITEM_TYPE:
		$ITEM_TYPE.text = "Red Flower"
	var OBJ_TEXTURE: Texture2D = load("res://Textures/Inventory/" + ITEM_TYPE + ".png")
	if OBJ_TEXTURE == null:
		print("Failed to load texture: res://Textures/Inventory/" + ITEM_TYPE + ".png")
	else:
		$Sprite2D.texture = OBJ_TEXTURE
	mouse_over_timer.connect("timeout", Callable(self, "_on_mouse_over_timeout"))
	
	# Ensure the timer is added to the scene tree
	if not mouse_over_timer.is_inside_tree():
		add_child(mouse_over_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if debounce_timer > 0:
		debounce_timer -= delta
	else:
		can_create_pickup = true

	if draggable:                                                                    
		if Input.is_action_just_pressed("inventory_click"):
			if mouse_over_timer.time_left == 0:
				initialPos = global_position
				InventoryManager.is_dragging = true
				self.z_index = 10
				InventoryManager.item_ref = ITEM_TYPE
		if Input.is_action_pressed("inventory_click") and InventoryManager.is_dragging:
			global_position = get_global_mouse_position()
		elif Input.is_action_just_released("inventory_click"):
			if InventoryManager.is_inside_boundary and can_create_pickup:
				InventoryManager.is_dragging = false
				slot_inside.set_populated(false)
				var PARENT = self.get_parent()
				PARENT.remove_child(self)
				can_create_pickup = false
				debounce_timer = 0.2 # Reset debounce timer
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

func _on_area_2d_body_entered(body):
	if body.is_in_group("dropable") and !InventoryManager.is_inside_checker:  
		if $PopulatedOnStartup.time_left > 0.0:
			slot_inside = body
		is_inside_dropable = true 
		
		body_ref = body

func _on_area_2d_body_exited(body):
	if body.is_in_group("dropable"):
		is_inside_dropable = false
		

func _on_area_2d_mouse_entered():
	if not InventoryManager.is_dragging:
		mouse_over_timer.start()
		scale = Vector2(1.05, 1.05)

func _on_area_2d_mouse_exited():
	if not InventoryManager.is_dragging:
		mouse_over_timer.stop()
		draggable = false
		scale = Vector2(1.0, 1.0)

func _on_mouse_over_timeout():
	draggable = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("draggable"):
		InventoryManager.is_inside_checker = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("draggable"):
		InventoryManager.is_inside_checker = false
