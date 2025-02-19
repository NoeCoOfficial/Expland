# ============================================================= #
# DebugManager.gd [AUTOLOAD]
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

var is_debugging = false

func _input(event: InputEvent) -> void:
	if OS.has_feature("debug"):
		if Input.is_action_just_pressed("print_objects"):
			print("Objects: ", Performance.get_monitor(Performance.OBJECT_COUNT))
			print("Nodes: ", Performance.get_monitor(Performance.OBJECT_NODE_COUNT))
			print("Orphan Nodes: ", Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))
			print("Textures: ", Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED) / 1048576, " MB") # Convert from bytes to MB
			print("Video Memory Used: ", Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / 1048576, " MB")
			print("Total Memory Used: ", Performance.get_monitor(Performance.MEMORY_STATIC) / 1048576, " MB")
			print("--------------------------------")
