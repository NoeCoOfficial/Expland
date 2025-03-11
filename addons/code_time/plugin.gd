@tool
extends EditorPlugin

const TimerPanel = preload("res://addons/code_time/timer_panel.gd")
const TIMER_PANEL = preload("res://addons/code_time/timer_panel.tscn")

var timer_panel: TimerPanel
var menu_bar: Control
var item_list: ItemList
var base_editor: CodeEdit:
	set(value):
		if is_instance_valid(base_editor):
			if base_editor.is_connected("text_changed", _on_base_editor_text_changed):
				base_editor.disconnect("text_changed", _on_base_editor_text_changed)
		
		base_editor = value
		if is_instance_valid(base_editor):
			base_editor.connect("text_changed", _on_base_editor_text_changed)

func _enter_tree() -> void:
	main_screen_changed.connect(_on_main_screen_changed)

func _ready() -> void:
	timer_panel = TIMER_PANEL.instantiate()
	menu_bar = EditorInterface.get_script_editor().get_children()[0].get_children()[0]
	menu_bar.add_child(timer_panel)
	menu_bar.move_child(timer_panel, 7)
	item_list = EditorInterface.get_script_editor().get_children()[0].get_children()[1].get_children()[0].get_children()[0].get_children()[1]
	item_list.connect("item_selected", _on_item_list_selected)

func _exit_tree() -> void:
	menu_bar.remove_child(timer_panel)
	timer_panel = null
	menu_bar = null
	item_list = null
	base_editor = null

func get_base_editor() -> CodeEdit:
	return EditorInterface.get_script_editor().get_current_editor().get_base_editor()

func _on_main_screen_changed(screen_name: String) -> void:
	if screen_name == "Script":
		base_editor = get_base_editor()

func _on_base_editor_text_changed() -> void:
	if timer_panel.timer.is_stopped():
		timer_panel.timer.start()
	
	if timer_panel.timer.paused:
		timer_panel.timer.paused = false

func _on_item_list_selected(index: int) -> void:
	base_editor = get_base_editor()
