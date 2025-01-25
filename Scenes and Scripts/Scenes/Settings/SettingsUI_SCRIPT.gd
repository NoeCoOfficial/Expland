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

func nodeSetup():
	$MainLayer/SettingsTabContainer.current_tab = 0
	
	$GreyLayer.modulate = Color(1, 1, 1, 0)
	
	$MainLayer/SettingsTabContainer/Graphics/PrettyShadowsSwitch.button_pressed = PlayerSettingsData.PrettyShadows
	$MainLayer/SettingsTabContainer/General/SSCSwitch.button_pressed = PlayerSettingsData.showStartupScreen
	$MainLayer/SettingsTabContainer/General/AutosaveIntervalSpinBox.value = PlayerSettingsData.autosaveInterval
	$MainLayer/SettingsTabContainer/Graphics/DOFBlurSwitch.button_pressed = PlayerSettingsData.DOFBlur
	$MainLayer/SettingsTabContainer/Video/FOVSlider.value = PlayerSettingsData.FOV
	$MainLayer/SettingsTabContainer/Video/SENSITIVITYSlider.value = PlayerSettingsData.Sensitivity * 10
	$MainLayer/SettingsTabContainer/Sound/MasterSlider.value = PlayerSettingsData.Master_Volume
	$MainLayer/SettingsTabContainer/Sound/MusicSlider.value = PlayerSettingsData.music_Volume
	$MainLayer/SettingsTabContainer/Sound/SFXSlider.value = PlayerSettingsData.sfx_Volume

func _ready() -> void:
	PlayerSettingsData.loadSettings()
	
	if !OS.has_feature("debug"):
		$SaveSettings.hide()
	
	Utils.set_center_offset($MainLayer)
	$MainLayer.scale = Vector2(0.0, 0.0)
	self.visible = false
	
	nodeSetup()

func _process(_delta: float) -> void:
	
	$MainLayer/SettingsTabContainer/Video/FOVValue.text = str(PlayerSettingsData.FOV)
	$MainLayer/SettingsTabContainer/Video/SENSITIVITYValue.text = str(PlayerSettingsData.Sensitivity)
	$MainLayer/SettingsTabContainer/Sound/MasterValue.text = str(int(PlayerSettingsData.Master_Volume * 100))
	$MainLayer/SettingsTabContainer/Sound/MusicValue.text = str(int(PlayerSettingsData.music_Volume * 100))
	$MainLayer/SettingsTabContainer/Sound/SFXValue.text = str(int(PlayerSettingsData.sfx_Volume * 100))


func openSettings(animationTime : float):
	PlayerSettingsData.loadSettings()
	PauseManager.is_inside_settings = true
	
	self.visible = true
	
	
	var tween = get_tree().create_tween().set_parallel()
	
	tween.tween_property($MainLayer, "scale", Vector2(1.0, 1.0), animationTime).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($GreyLayer, "modulate", Color(1, 1, 1, 1), animationTime)

func closeSettings(animationTime : float):
	PauseManager.is_inside_settings = false
	PlayerSettingsData.saveSettings()
	
	var tween = get_tree().create_tween().set_parallel()
	
	tween.tween_property($MainLayer, "scale", Vector2(0.0, 0.0), animationTime).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($GreyLayer, "modulate", Color(1, 1, 1, 0), animationTime)

	
	await get_tree().create_timer(animationTime).timeout
	
	self.visible = false


func _on_exit_settings_button_pressed() -> void:
	closeSettings(0.5)

func _on_fov_slider_value_changed(value: float) -> void:
	PlayerSettingsData.FOV = int(value)

func _on_sensitivity_slider_value_changed(value: float) -> void:
	PlayerSettingsData.Sensitivity = value / 10

func _on_master_slider_value_changed(value: float) -> void:
	PlayerSettingsData.Master_Volume = value

func _on_music_slider_value_changed(value: float) -> void:
	PlayerSettingsData.music_Volume = value

func _on_sfx_slider_value_changed(value: float) -> void:
	PlayerSettingsData.sfx_Volume = value

func _on_save_settings_pressed() -> void:
	PlayerSettingsData.saveSettings()

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

func _on_autosave_interval_spin_box_value_changed(value: float) -> void:
	PlayerSettingsData.autosaveInterval = int(value)
	PlayerSettingsData.set_autosave_interval(int(value))

func _on_pretty_shadows_switch_toggled(toggled_on: bool) -> void:
	if toggled_on:
		PlayerSettingsData.set_pretty_shadows(true)
	else:
		PlayerSettingsData.set_pretty_shadows(false)
