# ============================================================= #
# Utils.gd [AUTOLOAD]
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

extends Node

func format_number(n: int) -> String: # A function for formatting numbers easily. Must be an integer!
	if n >= 1_000: # if the number is greater than or equal to 1,000

		var i:float = snapped(float(n)/1_000, .01) # snap the number to the nearest 0.01
		return str(i).replace(",", ".") + "k" # return the number as a string with a "k" at the end

	elif n >= 1_000_000: # if the number is greater than or equal to 1,000,000

		var i:float = snapped(float(n)/1_000_000, .01) # snap the number to the nearest 0.01
		return str(i).replace(",", ".") + "M" # return the number as a string with a "M" at the end

	elif n >= 1_000_000_000: # if the number is greater than or equal to 1,000,000,000

		var i:float = snapped(float(n)/1_000_000_000, .01) # snap the number to the nearest 0.01
		return str(i).replace(",", ".") + "B" # return the number as a string with a "B" at the end

	elif n >= 1_000_000_000_000: # if the number is greater than or equal to 1,000,000,000,000

		var i:float = snapped(float(n)/1_000_000_000_000, .01) # snap the number to the nearest 0.01
		return str(i).replace(",", ".") + "T" # return the number as a string with a "T" at the end

	elif n >= 1_000_000_000_000_000: # if the number is greater than or equal to 1,000,000,000,000,000

		var i:float = snapped(float(n)/1_000_000_000_000_000, .01) # snap the number to the nearest 0.01
		return str(i).replace(",", ".") + "aa" # return the number as a string with a "aa" at the end

	else: 

		return str(n) # return the number as a string if it doesn't meet any of the above conditions

func _get_mouse_pos(): # get the position of the cursor.
	return get_viewport().get_mouse_position() # return the position of the cursor

func center_mouse_cursor(): # center the mouse cursor (relative to the viewport size)
	var viewport = get_viewport() # get the viewport
	var viewport_size = viewport.get_visible_rect().size # get the size of the viewport
	var center_position = viewport_size / 2 # get the center position of the viewport
	viewport.warp_mouse(center_position) # warp the mouse to the center position

func wait(seconds: float) -> void: # wait until the next line of code is executed. Similar to time.sleep() in python.
	await get_tree().create_timer(seconds).timeout # wait until the timer is finished

func set_center_offset(node : Node): # set the offset of a control node to the center of it
	var node_size = node.get_size()
	node.set_pivot_offset(Vector2(node_size/2))

func vector3_to_dict(vec: Vector3) -> Dictionary: # Converts a Vector3 value to a dictionary.
	return {"x": vec.x, "y": vec.y, "z": vec.z}

func dict_to_vector3(dict: Dictionary) -> Vector3: # Converts a dictionary value to a Vector3 value.
	return Vector3(dict["x"], dict["y"], dict["z"])
