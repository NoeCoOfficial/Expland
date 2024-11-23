# ============================================================= #
# Player_SCRIPT.gd
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

extends Label

var pressed_inputs = {}

func _process(_delta):
	# List of actions to check
	var actions = [
		{"name": "Jump", "action": "Jump"},
		{"name": "Move Forward", "action": "move_forward"},
		{"name": "Move Backward", "action": "move_backward"},
		{"name": "Move Left", "action": "move_left"},
		{"name": "Move Right", "action": "move_right"},
		{"name": "Quit", "action": "Quit"},
		{"name": "Sprint", "action": "Sprint"},
		{"name": "Reset", "action": "Reset"},
		{"name": "Exit", "action": "Exit"},
		{"name": "Inventory", "action": "Inventory"},
		{"name": "Left Click", "action": "LeftClick"},
		{"name": "Right Click", "action": "RightClick"},
		{"name": "Crouch", "action": "Crouch"},
		{"name": "Save Game", "action": "SaveGame"},
		{"name": "Interact", "action": "Interact"}
	]
	
	# Update the set of pressed inputs based on current state
	for action_data in actions:
		var action_name = action_data["name"]
		var action = action_data["action"]
		
		if Input.is_action_pressed(action):
			pressed_inputs[action_name] = true  # Add or keep in the set
		else:
			pressed_inputs.erase(action_name)  # Remove from the set if not pressed

	# Update the label's text with a comma-separated list of pressed inputs
	self.text = ", ".join(pressed_inputs.keys())
