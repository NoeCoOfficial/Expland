# ============================================================= #
# SettingsUI_SCRIPT.gd
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

@icon("res://Textures/Icons/Script Icons/32x32/settings_gear.png")
extends Control

@export var greyOverlay : ColorRect

func nodeSetup():
	$SettingsTabContainer/General/SSCSwitch.button_pressed = PlayerSettingsData.showStartupScreen
	
	$SettingsTabContainer/Graphics/MotionBlurSwitch.button_pressed = PlayerSettingsData.MotionBlur
	$SettingsTabContainer/Graphics/DOFBlurSwitch.button_pressed = PlayerSettingsData.DOFBlur

	$SettingsTabContainer/Video/FOVSlider.value = PlayerSettingsData.FOV
	$SettingsTabContainer/Sound/MasterSlider.value = PlayerSettingsData.Master_Volume
	$SettingsTabContainer/Sound/MusicSlider.value = PlayerSettingsData.music_Volume
	$SettingsTabContainer/Sound/SFXSlider.value = PlayerSettingsData.sfx_Volume

func _ready() -> void:
	if !OS.has_feature("debug"):
		$SaveSettings.hide()
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
	tween.tween_property(self, "scale", Vector2(0.0, 0.0), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
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


func _on_motion_blur_switch_toggled(toggled_on: bool) -> void:
	if toggled_on:
		PlayerSettingsData.set_motion_blur(true)
	else:
		PlayerSettingsData.set_motion_blur(false)

func _on_dof_blur_switch_toggled(toggled_on: bool) -> void:
	if toggled_on:
		PlayerSettingsData.set_dof_blur(true)
	else:
		PlayerSettingsData.set_dof_blur(false)

func _on_ssc_switch_toggled(toggled_on: bool) -> void:
	if toggled_on:
		PlayerSettingsData.showStartupScreen = true
	else:
		PlayerSettingsData.showStartupScreen = false
