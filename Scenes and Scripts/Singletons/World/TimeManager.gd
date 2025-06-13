# ============================================================= #
# TimeManager.gd [AUTOLOAD]
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

extends Node

var CURRENT_TIME = 600 # Starting time is 10am.
var CURRENT_DAY = 1
var DAY_STATE = "DAY"







# Speedrun timer

var speedrun_timer_is_running: bool = false
var speedrun_timer_start_time: float = 0.0
var speedrun_timer_elapsed_time: float = 0.0

var _speedrun_timer_thread: Thread = null
var _speedrun_timer_should_run: bool = true

func _ready():
	_speedrun_timer_thread = Thread.new()
	_speedrun_timer_thread.start(Callable(self, "_speedrun_timer_loop"))

func _speedrun_timer_loop(_unused = null):
	while _speedrun_timer_should_run:
		if speedrun_timer_is_running:
			var current_time = Time.get_ticks_msec() / 1000.0
			speedrun_timer_elapsed_time = current_time - speedrun_timer_start_time
		await get_tree().process_frame  # Keeps the update lightweight
	return

func speedrun_timer_start():
	if not speedrun_timer_is_running:
		speedrun_timer_start_time = Time.get_ticks_msec() / 1000.0 - speedrun_timer_elapsed_time
		speedrun_timer_is_running = true

func speedrun_timer_stop():
	speedrun_timer_is_running = false

func speedrun_timer_reset():
	speedrun_timer_is_running = false
	speedrun_timer_elapsed_time = 0.0

func speedrun_timer_get_time() -> float:
	return speedrun_timer_elapsed_time

func speedrun_timer_get_formatted_time() -> String:
	var t = speedrun_timer_elapsed_time
	var minutes = int(t) / 60
	var secs = int(t) % 60
	var millis = int((t - int(t)) * 100)
	return "%02d:%02d.%02d" % [minutes, secs, millis]

func _exit_tree():
	_speedrun_timer_should_run = false
