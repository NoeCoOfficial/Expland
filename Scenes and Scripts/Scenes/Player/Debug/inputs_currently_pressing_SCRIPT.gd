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
		{"name": "Inventory Click", "action": "inventory_click"},
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
