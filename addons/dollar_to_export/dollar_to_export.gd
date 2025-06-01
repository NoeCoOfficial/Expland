@tool
extends EditorPlugin

var button: Button

func _enter_tree():
	button = Button.new()
	button.text = "Convert $ to @export"
	button.tooltip_text = "Replaces $Node references with @export NodePath variables"
	button.pressed.connect(_on_button_pressed)
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, button)

func _exit_tree():
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, button)
	button.queue_free()

func _on_button_pressed():
	var script_editor = get_editor_interface().get_script_editor()
	var script = script_editor.get_current_script()

	if script == null:
		print("No script open.")
		return

	var code := script.get_source_code()
	var modified_code := code
	var added_exports := {}

	var regex := RegEx.new()
	regex.compile(r'\$(\"[^\"]+\"|\'[^\']+\'|[a-zA-Z_][a-zA-Z0-9_]*)')
	var matches := regex.search_all(code)

	for match in matches:
		var full := match.get_string()
		var path := full.substr(1)  # remove the $
		if (path.begins_with('"') and path.ends_with('"')) or (path.begins_with("'") and path.ends_with("'")):
			path = path.substr(1, path.length() - 2)

		var var_name := path.to_snake_case()

		if not added_exports.has(var_name):
			added_exports[var_name] = path

		modified_code = modified_code.replace(full, "get_node(%s)" % var_name)

	var export_lines := ""
	for var_name in added_exports.keys():
		export_lines += "@export var %s: NodePath = \"%s\"\n" % [var_name, added_exports[var_name]]

	var lines := modified_code.split("\n")
	var insert_index := 0
	if lines[0].begins_with("extends"):
		insert_index = 1
	lines.insert(insert_index, export_lines.strip_edges())
	modified_code = "\n".join(lines)

	# Update script content
	script.set_source_code(modified_code)
	script.reload()
	script_editor.get_current_editor().set_text(modified_code)

	print("✔ Converted $Node references to @export NodePaths.")
