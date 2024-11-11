extends Control

@export var is_being_opened_by_a_button : bool


func nodeSetup():
	$SettingsTabContainer/Video/FOVSlider.value = PlayerSettingsData.FOV
	$SettingsTabContainer/Sound/MasterSlider.value = PlayerSettingsData.Master_Volume
	$SettingsTabContainer/Sound/MusicSlider.value = PlayerSettingsData.music_Volume
	$SettingsTabContainer/Sound/SFXSlider.value = PlayerSettingsData.sfx_Volume

func _ready() -> void:
	PlayerSettingsData.loadSettings()
	nodeSetup()


func _process(_delta: float) -> void:
	$SettingsTabContainer/Video/FOVValue.text = str(PlayerSettingsData.FOV)
	$SettingsTabContainer/Sound/MasterValue.text = str(int(PlayerSettingsData.Master_Volume * 100))
	$SettingsTabContainer/Sound/MusicValue.text = str(int(PlayerSettingsData.music_Volume * 100))
	$SettingsTabContainer/Sound/SFXValue.text = str(int(PlayerSettingsData.sfx_Volume * 100))

func _on_exit_settings_button_pressed() -> void:
	pass

func openSettings():
	pass

func closeSettings():
	pass


func _on_fov_slider_value_changed(value: float) -> void:
	PlayerSettingsData.FOV = value


func _on_master_slider_value_changed(value: float) -> void:
	PlayerSettingsData.Master_Volume = value

func _on_music_slider_value_changed(value: float) -> void:
	PlayerSettingsData.music_Volume = value

func _on_sfx_slider_value_changed(value: float) -> void:
	PlayerSettingsData.sfx_Volume = value





















func _on_save_settings_pressed() -> void:
	PlayerSettingsData.saveSettings()
