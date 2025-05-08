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

######## Story Mode ID's ########
#        1 - First message when click on story mode play button
#        2 - Second message when click on story mode play button, which after exiting takes you to story mode



var is_in_interface = false
var is_in_absolute_interface = false

var current_dialogue_index = 0
var dialogue_messages = []
var DialogueInterface
var MinimalDialogueInterface
var Current_StoryModeID

func _ready():
	pass

func setStoryModeID(StoryModeID):
	Current_StoryModeID = StoryModeID

func startDialogue(messages: Array) -> void:
	
	if !PauseManager.is_inside_settings and !PauseManager.is_paused and !PauseManager.inside_item_workshop and !InventoryManager.pockets_ui_open and !InventoryManager.chest_ui_open and !InventoryManager.workbench_ui_open:
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

var WorldBoundaryDialogue = [
	{"author": "???", 
	"message": "This part of The Island is under maintenance for now!",
	"duration": 1},
	
	{"author": "???", 
	"message": "It will be available in the full version of Expland, soon!",
	"duration": 1},
	
]


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
	"How could you let this happen?",
	"ERR___    MSG NOT FOUND ----_",
	"???",
	"Rebooting...",
	"... . -. -.. / .... . .-.. .--.",
]

var testDialogue = [
	
	{"author": "sebashtioon (Noe Co. dev)", 
	"message": "Woah! Wassup?",
	"duration": 0.5},
	
	{"author": "You", 
	"message": "Not much... there really isn't anything to do here.",
	"duration": 1},
	
	{"author": "sebashtioon", 
	"message": "Yeah yeah, I know. But it will all come soon, I promise.",
	"duration": 1},
	
	{"author": "You", 
	"message": "Okay... but when exactly are you going to release the game? Like it's first release that isn't a pre-release? v1.0.0?",
	"duration": 3},
	
	{"author": "sebashtioon", 
	"message": "Just know that I'm not entirely sure. The due date for this is July 23, 2025. So it will be somewhere around then, maybe in June. I really don't know.",
	"duration": 3},
	
	{"author": "sebashtioon", 
	"message": "I hope you're enjoying the test area that I set up though?",
	"duration": 1.5},
	
	{"author": "You", 
	"message": "Yeah... it's fine.",
	"duration": 1},
	
	{"author": "sebashtioon", 
	"message": "By the way, you can press E to open the inventory. and ESC to pause the game. Please report any bugs, remember!",
	"duration": 2.5},
	
	{"author": "You", 
	"message": "Alright! I'll be playing this game alot when it comes out.",
	"duration": 2},
	
	{"author": "sebashtioon", 
	"message": "Wow, thank you! You're support means the world to me and Tristan, the team at Noe Co.. Isn't that right, Tristan?",
	"duration": 3},
	
	{"author": "GoatsAreTB (Noe Co. dev)", 
	"message": "It truly does! Goats are the best.",
	"duration": 1.5},
	
	{"author": "sebashtioon", 
	"message": "Alright then, I'll leave you to it. Go explore.
	Best wishes,
	
	Seb and Tristan",
	"duration": 4},
]

################################################
################################################
################################################
################################################
################################################
################################################
################################################
################################################
################################################
################################################
################################################

var mainMenuStoryModeDialogue_1 = [
	{"author": "???", 
	"message": "Who is this?",
	"duration": 0.5},
	
	{"author": "???", 
	"message": "Analyzing user data...",
	"duration": 1},
	
	{"author": "???", 
	"message": "Oh... someone new. And your name is... Gavin, I presume?",
	"duration": 2},
	
	{"author": "???", 
	"message": "I don't think you know what you're getting yourself into.",
	"duration": 2},
	
]

var mainMenuStoryModeDialogue_2 = [
	{"author": "???", 
	"message": "Oh... it's you again.",
	"duration": 1},
	
	{"author": "???", 
	"message": "Why did you come back?",
	"duration": 1},
	
	{"author": "???", 
	"message": "*Sigh*......",
	"duration": 1},
	
	{"author": "???", 
	"message": "You're going to regret this.",
	"duration": 1},
	
	{"author": "???", 
	"message": "I will grant your request to enter, but I'm warning you.",
	"duration": 2},
	
	{"author": "???", 
	"message": "All the best. 
	
	See you on the other side.",
	"duration": 2},
	
]

################################################
################################################
################################################
################################################
################################################
################################################
################################################
################################################
################################################
################################################
################################################

var StoryMode_StartCutsceneDialogue_1 = [
		{"message": 
			'"I\'m on a journey."',
			"time": 1},
		
		{"message": 
			'"Three days out here already... hard to believe it has been so long since I have seen Doc."', 
			"time": 2.5},
			
		{"message": 
			'Just me and the waves and the smell of the sea, huh? Could get used to this, but I better not."', 
			"time": 2.5},
			
		{"message": 
			'"This trip is only the beginning of something much bigger."', 
			"time": 2.5}
	]

var StoryMode_StartCutsceneDialogue_2 = [
		{"message": 
			'"This job... it’s the chance I’ve been waiting for. Sunshine Co. doesn’t just hire anyone. What makes me special?"', 
			"time": 4.0},
			
		{"message": 
			'"A six-figure salary, building solar panels? I never thought I’d land something like that. Am I doing the right thing?"',
			"time": 4.0},
			
		{"message": 
			'"But here I am, on this yacht, heading to what could be the best decision of my life. Right?"',
			"time": 2.8},
			
	]

var StoryMode_StartCutsceneDialogue_3 = [
		{"message": 
			'"It’s kind of wild, though. Me. An amateur bodybuilder, getting a job like this."', 
			"time": 2.5},
			
		{"message": 
			'"Guess all those hours in the gym paid off after all. They wanted someone strong, and I’m their guy."',
			"time": 3.0},
			
		{"message": 
			'"Gavin, the strongest, now working with Sunshine Co. Kind of has a ring to it."',
			"time": 2.8},
			
	]

var StoryMode_StartCutsceneDialogue_4 = [
		{"message": 
			'"Mom thought I was crazy for taking the job. ‘You’re throwing your life away,’ she said. She doesn’t get it."', 
			"time": 4.0},
			
		{"message": 
			'"But hey, I didn’t want to spend the rest of my life behind some desk. I need something that challenges me."',
			"time": 3.0},
			
		{"message": 
			'"This is it. Building solar panels for a company that’s changing the world. It’s big. And I’m part of it."',
			"time": 3.0},
			
	]

var StoryMode_StartCutsceneDialogue_5 = [
		{"message": 
			'"I didn’t even want to take the plane. Way too expensive. 
			This yacht? My friends pitched in for it."', 
			"time": 3.0},
			
		{"message": 
			'"Good friends, huh? They know this is my shot, and they’ve had my back since day one."',
			"time": 2.5},
			
	]

var StoryMode_StartCutsceneDialogue_6 = [
		{"message": 
			'"Hold on... what’s that?"', 
			"time": 1.5},
			# Probably just a quick storm. No big deal, right?
		{"message": 
			'"Those clouds are getting dark fast… way too fast."',
			"time": 2.0},
		
		{"message": 
			'"Probably just a quick storm. No big deal, right?"',
			"time": 2.0},
	]

################################################
################################################
################################################
################################################
################################################
################################################
################################################
################################################
################################################
################################################
################################################

var StoryMode_Dialogue1 = [
	{"message": 
		'', 
		"time": 1.5},
	
	{"message": 
		'"...Where am I???"', 
		"time": 1.0},
	
	{"message": 
		'"My head hurts so much..."',
		"time": 2.0},
	
	{"message": 
		'"What even happened?"',
		"time": 2.0},
	
	#{"message": 
		#'"It looks like I\'m on some sort of island..."',
		#"time": 3.0},
	#
	#{"message": 
		#'',
		#"time": 5.0},
	#
	#{"message": 
		#'"That voice… I heard something. Something... saved me."',
		#"time": 3.0},
	#
	#{"message": 
		#'"But what was it? And why me?"',
		#"time": 2.0},
#
	#{"message": 
		#'',
		#"time": 8.0},
#
	#{"message": 
		#'"Okay, focus. You’re alive."',
		#"time": 1.5},
#
	#{"message": 
		#'"I think I should probably try an find somewhere to sleep..."',
		#"time": 3.0},
	#
	#{"message": 
		#'"Hmm... it is getting pretty dark, maybe I should try and find shelter or something?"',
		#"time": 4.0},
#
	#{"message": 
		#'"Yeah, I probably shoud do that."',
		#"time": 3.0},
]
