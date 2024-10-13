# ============================================================= #
# ItemPickupObject_SCRIPT.gd
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

extends Node3D

@export var ITEM_TYPE: String:
	set(value):
		ITEM_TYPE = value
		PATH_TO_OBJECT = "res://Assets/3D Models/Inventory Pickup Items/" + ITEM_TYPE + ".blend"
	get:
		return ITEM_TYPE

var PATH_TO_OBJECT: String

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayBobbingAnimation()
	PlaySpinningAnimation()
	var LOADED_OBJECT = load(PATH_TO_OBJECT)
	if LOADED_OBJECT == null:
		print("Failed to load object: ", PATH_TO_OBJECT)
	else:
		print("Object loaded successfully!")
		var INSTANTIATED_OBJECT = LOADED_OBJECT.instantiate()
		self.add_child(INSTANTIATED_OBJECT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func PlaySpinningAnimation():
	var tween = get_tree().create_tween()
	var current_rotation_y = self.rotation.y
	var final_rotation_y = current_rotation_y + 2 * PI  # Rotate 360 degrees
	tween.tween_property(self, "rotation:y", final_rotation_y, 3)
	tween.connect("finished", Callable(self, "_on_spinning_anim_finished"))

func _on_spinning_anim_finished():
	# Reset rotation to avoid floating-point precision issues
	self.rotation.y = fmod(self.rotation.y, 2 * PI)
	PlaySpinningAnimation()

func PlayBobbingAnimation():
	var tween = get_tree().create_tween()
	var default_y = self.position.y
	var final_y_top = default_y + 0.2
	var time = 1.3
	tween.tween_property(self, "position:y", final_y_top, time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:y", default_y, time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.connect("finished", Callable(self, "_on_bobbing_anim_finished"))

func _on_bobbing_anim_finished():
	PlayBobbingAnimation()
