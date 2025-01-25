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

var VOLUME_DB : float = -10.0
var songs : Array
var currently_playing_song : AudioStreamPlayer

func _ready() -> void:
	songs = []
	for child in get_children():
		if child is AudioStreamPlayer:
			songs.append(child)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("audio_Toggle"):
		if AudioManager.is_paused:
			Toggle(false, true)
		else:
			Toggle(true, true)
	
	if Input.is_action_just_pressed("audio_Next"):
		Next(AudioManager.CAN_FADE, true)
	
	if Input.is_action_just_pressed("audio_Prev"):
		Previous(AudioManager.CAN_FADE, true)

func Toggle(pause : bool, showNotification : bool):
	
	if pause:
		currently_playing_song.stream_paused = true
		AudioManager.is_paused = true
	else:
		currently_playing_song.stream_paused = false
		AudioManager.is_paused = false
	
	if showNotification:
		if !AudioManager.NotificationOnScreen:
			AudioManager.NotificationNode.spawnAudioNotification(AudioManager.is_paused, currently_playing_song.name)
		else:
			AudioManager.NotificationNode.updateNotification(AudioManager.is_paused, currently_playing_song.name)

func Next(fade : bool, showNotification : bool):
	var nextSong
	
	if currently_playing_song:
		if fade:
			var fadetween = get_tree().create_tween()
			fadetween.tween_property(currently_playing_song, "volume_db", -80, AudioManager.FADE_TIME)
			await get_tree().create_timer(AudioManager.FADE_TIME).timeout
			currently_playing_song.stop()
		else:
			currently_playing_song.stop()
	
	AudioManager.PREVIOUS_SONGS.append(currently_playing_song)
	if !AudioManager.IN_FRONT_SONGS.is_empty(): # If there are songs yet to be played in front
		nextSong = AudioManager.IN_FRONT_SONGS.pop_back()
	else: # If there are no songs yet to be played
		randomize()
		while true:
			nextSong = songs[randi() % songs.size()]
			if nextSong != currently_playing_song:
				break
	
	currently_playing_song = nextSong
	currently_playing_song.play()
	startFadeTimer(currently_playing_song.stream.get_length())
	
	if fade:
		currently_playing_song.volume_db = -80
		var fadetween = get_tree().create_tween()
		fadetween.tween_property(currently_playing_song, "volume_db", VOLUME_DB, AudioManager.FADE_TIME)
	
	if showNotification:
		if !AudioManager.NotificationOnScreen:
			AudioManager.NotificationNode.spawnAudioNotification(AudioManager.is_paused, currently_playing_song.name)
		else:
			AudioManager.NotificationNode.updateNotification(AudioManager.is_paused, currently_playing_song.name)


func Previous(fade : bool, showNotification : bool):
	if AudioManager.PREVIOUS_SONGS.is_empty():
		return
	
	var previousSong
	if currently_playing_song:
		if fade:
			var fadetween = get_tree().create_tween()
			fadetween.tween_property(currently_playing_song, "volume_db", -80, AudioManager.FADE_TIME)
			await get_tree().create_timer(AudioManager.FADE_TIME).timeout
			currently_playing_song.stop()
		else:
			currently_playing_song.stop()
	
	AudioManager.IN_FRONT_SONGS.append(currently_playing_song)
	previousSong = AudioManager.PREVIOUS_SONGS.pop_back()
	
	currently_playing_song = previousSong
	currently_playing_song.play()
	startFadeTimer(currently_playing_song.stream.get_length())
	
	if fade:
		currently_playing_song.volume_db = -80
		var fadetween = get_tree().create_tween()
		fadetween.tween_property(currently_playing_song, "volume_db", VOLUME_DB, AudioManager.FADE_TIME)
	
	if showNotification:
		if !AudioManager.NotificationOnScreen:
			AudioManager.NotificationNode.spawnAudioNotification(AudioManager.is_paused, currently_playing_song.name)
		else:
			AudioManager.NotificationNode.updateNotification(AudioManager.is_paused, currently_playing_song.name)

func StartSong(song : Node, fade : bool, showNotification : bool):
	pass

func Start(fade : bool, showNotification : bool):
	var nextSong
	randomize()
	while true:
		nextSong = songs[randi() % songs.size()]
		if nextSong != currently_playing_song:
			break
	
	currently_playing_song = nextSong
	currently_playing_song.play()
	startFadeTimer(currently_playing_song.stream.get_length())
	
	if fade:
		currently_playing_song.volume_db = -80
		var fadetween = get_tree().create_tween()
		fadetween.tween_property(currently_playing_song, "volume_db", VOLUME_DB, AudioManager.FADE_TIME)
	
	if showNotification:
		if !AudioManager.NotificationOnScreen:
			AudioManager.NotificationNode.spawnAudioNotification(AudioManager.is_paused, currently_playing_song.name)
		else:
			AudioManager.NotificationNode.updateNotification(AudioManager.is_paused, currently_playing_song.name)

func Stop(song : Node, fade : bool):
	pass

func FadeIn(song : Node):
	var fadetween = get_tree().create_tween()
	fadetween.tween_property(song, "volume_db", VOLUME_DB, AudioManager.FADE_TIME)

func FadeOut(song : Node):
	var fadetween = get_tree().create_tween()
	fadetween.tween_property(song, "volume_db", -80, AudioManager.FADE_TIME)

func get_currently_playing_song_node():
	return currently_playing_song

func _on_songs_finished() -> void:
	Next(AudioManager.CAN_FADE, true)

func startFadeTimer(lengthOfSong : float):
	$FadeTimer.stop()
	$FadeTimer.wait_time = lengthOfSong - AudioManager.FADE_TIME
	$FadeTimer.start()

func _on_fade_timer_timeout() -> void:
	FadeOut(currently_playing_song)
