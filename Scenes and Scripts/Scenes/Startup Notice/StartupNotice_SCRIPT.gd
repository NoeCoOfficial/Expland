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

@icon("res://Textures/Icons/Script Icons/32x32/dialogue_start.png")
extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !OS.has_feature("debug"):
		$Notice/DebugNotice.hide()
	
	$Notice/DebugNotice.self_modulate = Color(1, 1, 1, 0)
	$Notice.self_modulate = Color(1, 1, 1, 0)
	
	await get_tree().create_timer(1).timeout
	playTextFade()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func playTextFade():
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Notice, "self_modulate", Color(1, 1, 1, 1), 0.5)
	tween.tween_property($Notice/DebugNotice, "self_modulate", Color(1, 1, 1, 1), 0.5)
	tween.tween_property($Notice, "self_modulate", Color(1, 1, 1, 0), 0.5).set_delay(4)
	tween.tween_property($Notice/DebugNotice, "self_modulate", Color(1, 1, 1, 0), 0.5).set_delay(4)
	tween.connect("finished", Callable(self, "on_fade_finished"))

func on_fade_finished():
	call_deferred("change_to_main_menu")

func change_to_main_menu() -> void:
	get_tree().change_scene_to_file("res://Scenes and Scripts/Scenes/Main Menu/MainMenu.tscn")
