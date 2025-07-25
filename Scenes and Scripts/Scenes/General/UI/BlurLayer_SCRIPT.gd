# ============================================================= #
# BlurLayer_SCRIPT.gd
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

extends Control

@export var Blur : ColorRect
@export var Stop_Mouse : Control

var target_mat
var tween : Tween

func _ready() -> void:
	Blur.hide()
	target_mat = Blur.material
	
	target_mat.set_shader_parameter("blur_scale", 0.001)
	target_mat.set_shader_parameter("darkness", 1.0)

func fadeInBlur(time : float, blur_scale : float, stop_mouse : bool, darkness : float, pass_mouse : bool = false):
	if tween:
		tween.stop()
		tween.kill()
	
	Blur.show()
	if stop_mouse:
		Stop_Mouse.mouse_filter = Control.MOUSE_FILTER_STOP
	if pass_mouse:
		Stop_Mouse.mouse_filter = Control.MOUSE_FILTER_PASS
	
	tween = get_tree().create_tween().set_parallel()
	tween.tween_property(target_mat, "shader_parameter/blur_scale", blur_scale, time)
	tween.tween_property(target_mat, "shader_parameter/darkness", darkness, time)

func fadeOutBlur(time : float):
	if tween:
		tween.stop()
		tween.kill()
	
	tween = get_tree().create_tween().set_parallel()
	tween.connect("finished", on_fade_out_finished)
	tween.tween_property(target_mat, "shader_parameter/blur_scale", 0.001, time)
	tween.tween_property(target_mat, "shader_parameter/darkness", 1.0, time)

func on_fade_out_finished():
	Blur.hide()
	Stop_Mouse.mouse_filter = Control.MOUSE_FILTER_IGNORE
