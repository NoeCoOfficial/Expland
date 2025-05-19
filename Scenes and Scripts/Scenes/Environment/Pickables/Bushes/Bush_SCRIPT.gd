# ============================================================= #
# Bush_SCRIPT.gd
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

extends Node3D

@export var HarvestingFruit : AudioStreamPlayer3D
@export var SpawnBerriesTimer : Timer
@export var Berries : Node3D
@export var Bush : Node3D

var collected_berries : bool = false
 
func init_bush(clctd_berries : bool, time_left : float):
	if clctd_berries:
		collect_berries(true)
		SpawnBerriesTimer.wait_time = time_left
		SpawnBerriesTimer.start()

func get_bush_info():
	return {
		"collected_berries" : collected_berries,
		"time_left" : SpawnBerriesTimer.time_left
	}


func _on_berries_collected() -> void:
	if !collected_berries:
		SpawnBerriesTimer.wait_time = 3000
		collect_berries()

func _on_spawn_berries_timer_timeout() -> void:
	spawn_berries()


func collect_berries(silent : bool = false):
	$"Interactable Component".hide()
	if !silent:
		HarvestingFruit.play()
	
	collected_berries = true
	Berries.hide()
	SpawnBerriesTimer.start()

func spawn_berries():
	$"Interactable Component".show()
	collected_berries = false
	Berries.show()
