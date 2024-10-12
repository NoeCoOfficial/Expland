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
var initialPos:Vector2
var offset:Vector2
var slot
@export var ITEM_TYPE:String

func _ready():
	var OBJ_TEXTURE : Texture2D = load("res://Textures/Inventory/"+ ITEM_TYPE + ".png")
	$Sprite2D.texture = OBJ_TEXTURE



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if draggable:
		if Input.is_action_just_pressed("inventory_click"):
			initialPos = global_position
			offset = get_global_mouse_position() - global_position
			InventoryManager.is_dragging = true
		if Input.is_action_pressed("inventory_click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("inventory_click"):
			InventoryManager.is_dragging = false
			# debugging
			var slotNumber = slot[4]
			var debug_slot_number_label = get_node("/root/World/Player/Head/Camera3D/InventoryLayer/debug_slot_info")
			debug_slot_number_label.text = "You just released on slot number: " + slotNumber
			
			var tween = get_tree().create_tween()
			if is_inside_dropable:
				tween.tween_property(self, "position", body_ref.position, 0.1)
			else:
				tween.tween_property(self, "global_position", initialPos, 0.1)
				






func _on_area_2d_body_entered(body):
	if body.is_in_group("dropable"):
		
		# Get the name of the node and convert it to a String
		slot = body.get_name() as String
		
		
		is_inside_dropable = true
		
		# Start the tween
		var tween = get_tree().create_tween()
		tween.tween_property(body, "modulate", Color(1, 1, 1, 1), 0.2)
		body_ref = body



func _on_area_2d_body_exited(body):
	if body.is_in_group("dropable"):
		is_inside_dropable = false
		
		# body.modulate = Color(1, 1, 1, 0.2)
		
		var tween = get_tree().create_tween()
		tween.tween_property(body, "modulate", Color(1, 1, 1, 0.2), 0.2)










func _on_area_2d_mouse_entered():
	if not InventoryManager.is_dragging:
		draggable = true
		scale = Vector2(1.05, 1.05)


func _on_area_2d_mouse_exited():
	if not InventoryManager.is_dragging:
		draggable = false
		scale = Vector2(1.0, 1.0)
