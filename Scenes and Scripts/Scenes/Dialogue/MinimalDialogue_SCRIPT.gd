# ============================================================= #
# MinimalDialogue_SCRIPT.gd
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

extends Control

var message_queue = []
var is_displaying = false

func spawnMinimalDialogue(dialogue_list : Array):
	for dialogue in dialogue_list:
		message_queue.append(dialogue)
	if not is_displaying:
		_display_next_message()

func _display_next_message():
	if message_queue.size() > 0:
		is_displaying = true
		var message_data = message_queue.pop_front()
		var msg = message_data.get("message", "")
		var time = message_data.get("time", 1.0)
		
		$Text.show()
		$Text.modulate = Color(1, 1, 1, 1)
		$Text.visible_ratio = 0.0
		$Text.text = msg
		
		var tween = get_tree().create_tween().set_parallel()
		tween.tween_property($Text, "visible_ratio", 1.0, time)
		tween.tween_property($Text, "modulate", Color(1, 1, 1, 0), 1).set_delay(time + 2)
		tween.connect("finished", _on_tween_finished)
	else:
		is_displaying = false

func _on_tween_finished():
	_display_next_message()
