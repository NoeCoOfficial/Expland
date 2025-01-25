# ============================================================= #
# MainMenu_Audio_SCRIPT.gd
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

var songs : Array
var currently_playing_song : AudioStreamPlayer

func _ready() -> void:
	songs = self.get_children()

func Toggle(paused : bool, fade : bool, showNotification : bool):
	pass

func Next(fade : bool, showNotification : bool):
	var nextSong
	var fadetween = get_tree().create_tween()
	if currently_playing_song:
		fadetween.tween_property(currently_playing_song, "volume_db", -80, AudioManager.FADE_TIME)
		await get_tree().create_timer(AudioManager.FADE_TIME).timeout
		currently_playing_song.stop()
	
	AudioManager.PREVIOUS_SONGS.append(currently_playing_song)
	if !AudioManager.IN_FRONT_SONGS.is_empty():
		nextSong = AudioManager.IN_FRONT_SONGS[AudioManager.IN_FRONT_SONGS.size()]

func Previous(fade : bool, showNotification : bool):
	pass

func StartSong(song : Node, fade : bool, showNotification : bool):
	pass

func Start(fade : bool, showNotification : bool):
	pass

func Stop(song : Node, fade : bool):
	pass

func FadeIn(song : Node):
	pass

func FadeOut(song : Node):
	pass


func get_currently_playing_song_node():
	return currently_playing_song
