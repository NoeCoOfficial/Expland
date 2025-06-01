@tool
extends EditorPlugin

var button

func _enter_tree():
	button = Button.new()
	button.text = "Convert $ to @export"
	button.pressed.connect(_on_button_pressed)
	add_control_to_container(CONTAINER_TOOLBAR, button)

func _exit_tree():
	remove_control_from_container(CONTAINER_TOOLBAR, button)
	button.free()

func _on_button_pressed():
	var script_editor = get_editor_interface().get_script_editor()
	var current_editor = script_editor.get_current_editor()
	if current_editor == null:
		push_error("No script editor currently open!")
		return

	var code_edit = null
	for i in range(current_editor.get_child_count()):
		var child = current_editor.get_child(i)
		if child is VSplitContainer:
			code_edit = find_code_edit(child)
			break

	if code_edit == null:
		push_error("Could not find CodeEdit inside ScriptEditor!")
		return

	var code = code_edit.get_text()
	if code == "":
		push_error("Script source code is empty!")
		return

	# Find all $nodeName occurrences using regex
	var regex = RegEx.new()
	var err = regex.compile(r"\$([A-Za-z0-9_]+)")
	if err != OK:
		push_error("Regex compilation failed!")
		return

	var matches = regex.search_all(code)
	if matches.is_empty():
		# No $ references found
		code_edit.call_deferred("show_warning", "No $ node references found!")
		return

	# Collect unique node names
	var node_names = {}
	for match in matches:
		var node_name = match.get_string(1)
		node_names[node_name] = true

	# Prepare export lines to insert
	var export_lines = []
	for node_name in node_names.keys():
		var line = '@export var %s: NodePath = $"%s".get_path()' % [node_name, node_name]
		export_lines.append(line)

	# Insert export lines after extends/class_name/empty lines near top
	var lines = code.split("\n")
	var insert_index = 0
	for i in range(lines.size()):
		var line = lines[i].strip()
		if line.begins_with("extends") or line.begins_with("class_name") or line == "":
			insert_index = i + 1
		else:
			break
	lines.insert_array(insert_index, export_lines)

	# Replace $nodeName with nodeName in code lines
	for node_name in node_names.keys():
		var pattern = r"\$%s\b" % node_name
		regex.compile(pattern)
		lines = regex.sub(lines, node_name)

	var new_code = lines.join("\n")

	# Update the editor text with new code
	code_edit.set_text(new_code)
	code_edit.call_deferred("show_message", "Converted $ references to @export variables.")

	# Optional: Save the script resource
	var script = script_editor.get_current_script()
	if script:
		ResourceSaver.save(script.resource_path, script)

func find_code_edit(node: Node) -> Node:
	# Recursively find CodeEdit inside node
	if node is CodeEdit:
		return node
	for child in node.get_children():
		var found = find_code_edit(child)
		if found != null:
			return found
	return null
