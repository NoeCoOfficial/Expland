# ============================================================= #
# IslandManager.gd [AUTOLOAD]
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

var transitioning_from_menu
var transitioningFromNewIsland = false
var FreeMode_Island_Count : int

var Current_Island_Name = "Debug"
var Current_Game_Mode = ""

func _ready() -> void:
	if !OS.is_debug_build():
		Current_Island_Name = ""

func set_current_island(island_name: String) -> void:
	Current_Island_Name = island_name
	IslandAccessOrder.add_island(island_name)

func resetAttributes():
	
	# CRITICAL
	# EVERY VALUE ASSOCIATED WITH THE ISLAND AND/OR PLAYER
	# IT'S NAME AND IT'S DEFAULT VALUE MUST BE SET HERE!
	# VERY IMPORTANT!
	
	PauseManager.inside_explorer_note_ui = false
	PauseManager.inside_can_move_item_workshop = false
	PauseManager.inside_absolute_item_workshop = false
	PauseManager.inside_item_workshop = false
	PauseManager.is_inside_achievements_ui = false
	PauseManager.is_inside_alert = false
	PauseManager.is_inside_credits = false
	PauseManager.is_inside_settings = false
	PauseManager.is_paused = false
	
	PlayerData.GAME_STATE = "NORMAL"
	PlayerData.Health = 100
	PlayerData.Hunger = 100
	PlayerData.Hydration = 100
	PlayerManager.Stamina = 100
	InventoryData.CURRENT_ITEM_IN_HAND = ""
	IslandManager.Current_Island_Name = ""
	IslandManager.Current_Game_Mode = ""
	IslandManager.Current_Weather = ""
	IslandManager.transitioningFromNewIsland = false
	TimeManager.CURRENT_TIME = 600
	TimeManager.CURRENT_DAY = 1
	TimeManager.DAY_STATE = "DAY"
	
	WeatherManager.CURRENT_WEATHER = ""
	WeatherManager.CURRENT_WEATHER_ARR_INDEX = 0
	
	ExplorerNotesManager.COLLECTED_NOTES.clear()
	ExplorerNotesManager.CurrentlyInteracting_ID = null
	ExplorerNotesManager.CurrentlyShowing_ID = null
	ExplorerNotesManager.CurrentlyInteracting_Node = null
	ExplorerNotesManager.CurrentlyShowing_Node = null
	ExplorerNotesManager.UI_CurrentlyFocusedIndex = null
	ExplorerNotesManager.UI_CurrentLeftIndex = null
	ExplorerNotesManager.UI_CurrentRightIndex = null
	ExplorerNotesManager.UI_CurrentlyFocusedID = null
	ExplorerNotesManager.UI_CurrentLeftID = null
	ExplorerNotesManager.UI_CurrentRightID = null
	ExplorerNotesManager.EXPLORER_NOTES_MAIN_LAYER = null
	
	InventoryManager.creatingFromInventory = false
	InventoryManager.inventory_open = false
	InventoryManager.in_chest_interface = false
	InventoryManager.is_in_workbench_interface = false
	InventoryManager.is_dragging = false
	InventoryManager.is_inside_boundary = false
	InventoryManager.item_ref = ""
	InventoryManager.item_ref_not_at_inventory = ""
	InventoryManager.is_creating_pickup = false
	InventoryManager.is_inside_checker = false
	InventoryManager.chestNode = null
	
	CraftingManager.resetCurrentCraftingItems()
	
	HotbarManager.CURRENTLY_SELECTED_SLOT_NAME = null
	
	InteractionManager.is_notification_on_screen = false
	InteractionManager.is_colliding = false
	InteractionManager.is_hovering_over_email_noeco = false
	InteractionManager.is_hovering_over_feedback_github = false
	InteractionManager.is_hovering_over_test_obj = false
	InteractionManager.is_hovering_over_sackcloth_bed = false
	InteractionManager.is_hovering_over_chest = false
	InteractionManager.is_hovering_over_workbench = false
	InteractionManager.is_hovering_over_explorer_note = false
	
	AchievementsManager.NotificationOnScreen = false
	
	# NOTE: May need to reset TerrainManager variables here in future
	
