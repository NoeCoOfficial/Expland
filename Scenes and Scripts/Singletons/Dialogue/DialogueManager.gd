# ============================================================= #
# DialogueManager.gd [AUTOLOAD]
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

var is_in_interface = false
var is_in_absolute_interface = false
var current_dialogue_index = 0
var dialogue_messages = []
var DialogueInterface

func _ready():
	pass

func startDialogue(messages: Array) -> void:
	if !PauseManager.is_inside_settings and !PauseManager.is_paused and !InventoryManager.inventory_open:
		dialogue_messages = messages
		current_dialogue_index = 0
		showNextMessage()

func showNextMessage() -> void:
	if current_dialogue_index < dialogue_messages.size():
		var message_data = dialogue_messages[current_dialogue_index]
		DialogueInterface.spawnDialogue(message_data["author"], message_data["message"], message_data["duration"])
		current_dialogue_index += 1
	else:
		DialogueInterface.despawnDialogue()

########################################################################
# Dialogues
########################################################################

var deathScreenRandomText = [ # a list of random text to display when the player dies
	"Pull yourself together.", 
	"Why did you have to die?",
	"You will never get back now.",
	"Your soul has been sealed.",
	"You have now become one with the sky.",
	"What have you done?",
	"As you die, they will make more.",
	"The more you fight, the more you lose.",
	"Every fail you have the more they succeed.",
	"Even gods fall.",
	"There have been many cycles.",
	"Why am I even talking to you?",
	"Stop kidding yourself. This isn't a game.",
	"What did you do?",
	"You did everything to deserve this.",
	"Your story ends here.",
	"Not even time can save you now.",
	"Everything you know has crumbled.",
	"The end is inevitable.",
	"No one will remember you.",
	"All your efforts were in vain.",
	"This world doesn't need you anymore.",
	"The void welcomes you.",
	"Was it worth it?",
	"Death is just the beginning.",
	"Your journey ends in silence.",
	"Only shadows remain.",
	"Hope fades into the darkness.",
	"Your struggle was meaningless.",
	"Nothing can undo what you've done.",
	"How could you let this happen?"
]
