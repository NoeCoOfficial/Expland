# ============================================================= #
# Utils.gd [AUTOLOAD]
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

func get_project_version() -> String:
	var config = ConfigFile.new()
	var err = config.load("res://project.godot")
	if err != OK:
		print("Failed to load project.godot")
		return "Unknown"
	var version = config.get_value("application", "config/version", "Unknown")
	return version
