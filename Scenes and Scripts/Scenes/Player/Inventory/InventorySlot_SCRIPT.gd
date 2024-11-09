# ============================================================= #
# InventorySlot_SCRIPT.gd
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

extends StaticBody2D

@export var is_touching_draggable = false
@export var populated = false

func _ready():
	await get_tree().create_timer(0.1).timeout
	modulate = Color(1, 1, 1, 0.2)


func _process(_delta):
	if InventoryManager.is_dragging:
		visible = true
	else:
		visible = false


func is_populated():
	if populated:
		return true
	else:
		return false

func set_populated(populatedValue : bool):
	if populatedValue:
		populated = true
	else:
		populated = false


func _on_draggable_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("draggable"):
		is_touching_draggable = true

func _on_draggable_detector_area_exited(area: Area2D) -> void:
	if area.is_in_group("draggable"):
		is_touching_draggable = false

## 500 Commits. GG!
