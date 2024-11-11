extends Control

func nodeSetup():
	$SettingsTabContainer/Video/FOVSlider.value = PlayerSettingsData.FOV
	


func _ready() -> void:
	PlayerSettingsData.loadSettings()
	nodeSetup()


func _process(_delta: float) -> void:
	$SettingsTabContainer/Video/FOVValue.text = str(PlayerSettingsData.FOV)


func _on_exit_settings_button_pressed() -> void:
	pass

func openSettings():
	pass


func closeSettings():
	pass


func _on_fov_slider_value_changed(value: float) -> void:
	PlayerSettingsData.FOV = value


func _on_save_settings_pressed() -> void:
	PlayerSettingsData.saveSettings()
