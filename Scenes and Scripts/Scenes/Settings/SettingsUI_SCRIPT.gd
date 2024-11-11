extends Control

@onready var greyOverlay = $GreyLayer

func nodeSetup():
	$SettingsTabContainer/Video/FOVSlider.value = PlayerSettingsData.FOV
	$SettingsTabContainer/Sound/MasterSlider.value = PlayerSettingsData.Master_Volume
	$SettingsTabContainer/Sound/MusicSlider.value = PlayerSettingsData.music_Volume
	$SettingsTabContainer/Sound/SFXSlider.value = PlayerSettingsData.sfx_Volume

func _ready() -> void:
	Utils.set_center_offset(self)
	self.scale = Vector2(0.0, 0.0)
	self.visible = false
	
	$GreyLayer.self_modulate = Color(1, 1, 1, 0)
	
	
	PlayerSettingsData.loadSettings()
	nodeSetup()


func _process(_delta: float) -> void:
	$SettingsTabContainer/Video/FOVValue.text = str(PlayerSettingsData.FOV)
	$SettingsTabContainer/Sound/MasterValue.text = str(int(PlayerSettingsData.Master_Volume * 100))
	$SettingsTabContainer/Sound/MusicValue.text = str(int(PlayerSettingsData.music_Volume * 100))
	$SettingsTabContainer/Sound/SFXValue.text = str(int(PlayerSettingsData.sfx_Volume * 100))

func openSettings():
	PlayerSettingsData.loadSettings()
	self.visible = true
	showOverlay(true, 0.3)
	## TODO: show layer with zoom effect

func closeSettings():
	PlayerSettingsData.saveSettings()
	hideOverlay(true, 0.3)

func showOverlay(withFade : bool, fadeTime : float):
	if withFade:
		greyOverlay.visible = true
		var tween = get_tree().create_tween()
		tween.tween_property(greyOverlay, "self_modulate", Color(1, 1, 1, 1), fadeTime)
	else:
		greyOverlay.visible = true
		greyOverlay.self_modulate = Color(1, 1, 1, 1)

func hideOverlay(withFade : bool, fadeTime : float):
	if withFade:
		var tween = get_tree().create_tween()
		tween.tween_property(greyOverlay, "self_modulate", Color(1, 1, 1, 0), fadeTime)
		tween.tween_property(greyOverlay, "visible", false, 0)
	else:
		greyOverlay.visible = false
		greyOverlay.self_modulate = Color(1, 1, 1, 0)

func _on_exit_settings_button_pressed() -> void:
	closeSettings()

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
