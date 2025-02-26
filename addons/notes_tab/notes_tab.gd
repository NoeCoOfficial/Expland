#=============================================================================#
# Notes Tab                                                                   #
# Copyright (C) 2018-Present Michael Alexsander                               #
#-----------------------------------------------------------------------------#
# This file is part of Notes Tab.                                             #
#                                                                             #
# Notes Tab is free software: you can redistribute it and/or modify           #
# it under the terms of the GNU General Public License as published by        #
# the Free Software Foundation, either version 3 of the License, or           #
# (at your option) any later version.                                         #
#                                                                             #
# Notes Tab is distributed in the hope that it will be useful,                #
# but WITHOUT ANY WARRANTY; without even the implied warranty of              #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               #
# GNU General Public License for more details.                                #
#                                                                             #
# You should have received a copy of the GNU General Public License           #
# along with Notes Tab.  If not, see <http://www.gnu.org/licenses/>.          #
#=============================================================================#

@tool
extends EditorPlugin


var _notes_tab: TextEdit


func _enter_tree() -> void:
	_notes_tab = TextEdit.new()
	_notes_tab.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_notes_tab.custom_minimum_size.y = 150

	# Load previous text state.
	var editor_settings: EditorSettings = EditorInterface.get_editor_settings()
	_notes_tab.text =\
			editor_settings.get_project_metadata("notes_tab", "notes", "")
	# If no previous cursor position is found, put it in the end of the text.
	_notes_tab.set_caret_line(editor_settings.get_project_metadata("notes_tab",
			"cursor_line", _notes_tab.get_line_count() - 1) as int)
	_notes_tab.set_caret_column(editor_settings.get_project_metadata(
			"notes_tab", "cursor_column", _notes_tab.get_line(
			_notes_tab.get_line_count() - 1).length()) as int)

	add_control_to_bottom_panel(_notes_tab, "Notes")

	_notes_tab.visibility_changed.connect(_on_notes_tab_visibility_changed)

	_update_settings()
	editor_settings.settings_changed.connect(_update_settings)


func _exit_tree() -> void:
	remove_control_from_bottom_panel(_notes_tab)
	
	_notes_tab.queue_free()


func _save_external_data() -> void:
	var editor_settings: EditorSettings = EditorInterface.get_editor_settings()
	editor_settings.set_project_metadata("notes_tab", "notes", _notes_tab.text)
	editor_settings.set_project_metadata("notes_tab", "cursor_line",
			_notes_tab.get_caret_line())
	editor_settings.set_project_metadata("notes_tab", "cursor_column",
			_notes_tab.get_caret_column())


func _update_settings() -> void:
	# Use some of the editor settings in the notes, for consistency.
	var editor_settings: EditorSettings = EditorInterface.get_editor_settings()
	_notes_tab.caret_type =\
			editor_settings.get_setting("text_editor/appearance/caret/type")
	_notes_tab.caret_blink = editor_settings.get_setting(
			"text_editor/appearance/caret/caret_blink")
	_notes_tab.caret_blink_interval = editor_settings.get_setting(
			"text_editor/appearance/caret/caret_blink_interval")


func _on_notes_tab_visibility_changed() -> void:
	if _notes_tab.visible:
		_notes_tab.grab_focus()
