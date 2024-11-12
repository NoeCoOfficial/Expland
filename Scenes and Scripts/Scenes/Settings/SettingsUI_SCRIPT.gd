# ============================================================= #
# SettingsUI_SCRIPT.gd
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

extends Control

@export var greyOverlay : ColorRect

func nodeSetup():
	$SettingsTabContainer/Video/FOVSlider.value = PlayerSettingsData.FOV
	$SettingsTabContainer/Sound/MasterSlider.value = PlayerSettingsData.Master_Volume
	$SettingsTabContainer/Sound/MusicSlider.value = PlayerSettingsData.music_Volume
	$SettingsTabContainer/Sound/SFXSlider.value = PlayerSettingsData.sfx_Volume

func _ready() -> void:
	greyOverlay.visible = false
	Utils.set_center_offset(self)
	self.scale = Vector2(0.0, 0.0)
	self.visible = false
	
	PlayerSettingsData.loadSettings()
	nodeSetup()

func _process(_delta: float) -> void:
	$SettingsTabContainer/Video/FOVValue.text = str(PlayerSettingsData.FOV)
	$SettingsTabContainer/Sound/MasterValue.text = str(int(PlayerSettingsData.Master_Volume * 100))
	$SettingsTabContainer/Sound/MusicValue.text = str(int(PlayerSettingsData.music_Volume * 100))
	$SettingsTabContainer/Sound/SFXValue.text = str(int(PlayerSettingsData.sfx_Volume * 100))

func openSettings():
	PlayerSettingsData.loadSettings()
	PauseManager.is_inside_settings = true
	showOverlay(true, 0.2)
	self.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func closeSettings():
	PauseManager.is_inside_settings = false
	hideOverlay(true, 0.2)
	PlayerSettingsData.saveSettings()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(0.0, 0.0), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "visible", false, 0.0)


func showOverlay(withFade : bool, fadeTime : float):
	if withFade:
		greyOverlay.visible = true
		greyOverlay.self_modulate = Color(1, 1, 1, 0)
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
