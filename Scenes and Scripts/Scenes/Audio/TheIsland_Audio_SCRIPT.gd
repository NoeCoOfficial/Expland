# ============================================================= #
# TheIsland_Audio_SCRIPT.gd
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

var canOperate : bool = true

var RESERVED_SONGS = [
	"Ear Bleed",
	"Midnight Murmurs",
	"Before Dark",
	"Unfamiliar Lights",
	"A New Beginning",
]

@export var NIGHT_SONGS : Array[AudioStreamPlayer]
@export var MORNING_SONGS : Array[AudioStreamPlayer]

func _ready() -> void:
	AudioManager.ISLAND_NIGHT_SONGS = NIGHT_SONGS
	AudioManager.ISLAND_MORNING_SONGS = MORNING_SONGS
	songs = []
	for child in get_children():
		if child is AudioStreamPlayer:
			songs.append(child)

func _process(_delta: float) -> void:
	AudioManager.FADE_TIMER_TIME_LEFT = $FadeTimer.time_left

func _input(_event: InputEvent) -> void:
	if !Global.the_island_transitioning_scene:
		if Input.is_action_just_pressed("audio_Toggle") and canOperate:
			if AudioManager.is_paused:
				Toggle(false, true)
			else:
				Toggle(true, true)
			canOperate = false
			$DebounceTimer.start()
		
		if Input.is_action_just_pressed("audio_Next") and canOperate:
			Next(AudioManager.CAN_FADE, true)
			canOperate = false
			$DebounceTimer.start()
		
		if Input.is_action_just_pressed("audio_Prev") and canOperate:
			Previous(AudioManager.CAN_FADE, true)
			canOperate = false
			$DebounceTimer.start()

func Toggle(pause : bool, showNotification : bool):
	
	if pause:
		$FadeTimer.set_paused(true)
		currently_playing_song.stream_paused = true
		AudioManager.is_paused = true
	else:
		$FadeTimer.set_paused(false)
		currently_playing_song.stream_paused = false
		AudioManager.is_paused = false
	
	if showNotification:
		if !AudioManager.NotificationOnScreen:
			AudioManager.NotificationNode.spawnAudioNotification(AudioManager.is_paused, currently_playing_song.name)
		else:
			AudioManager.NotificationNode.updateNotification(AudioManager.is_paused, currently_playing_song.name)

func Next(fade : bool, showNotification : bool):
	if !AudioManager.is_paused:
		var nextSong
		
		if currently_playing_song:
			if fade:
				FadeOut(currently_playing_song)
			else:
				currently_playing_song.stop()
		
		AudioManager.PREVIOUS_SONGS.append(currently_playing_song)
		if !AudioManager.IN_FRONT_SONGS.is_empty():
			nextSong = AudioManager.IN_FRONT_SONGS.pop_back()
		else:
			randomize()
			while true:
				nextSong = songs[randi() % songs.size()]
				if nextSong != currently_playing_song and nextSong.name not in RESERVED_SONGS:
					break
		
		currently_playing_song = nextSong
		currently_playing_song.play()
		startFadeTimer(currently_playing_song.stream.get_length())
		
		if fade:
			FadeIn(currently_playing_song)
		
		if showNotification:
			if !AudioManager.NotificationOnScreen:
				AudioManager.NotificationNode.spawnAudioNotification(AudioManager.is_paused, currently_playing_song.name)
			else:
				AudioManager.NotificationNode.updateNotification(AudioManager.is_paused, currently_playing_song.name)

func Previous(fade : bool, showNotification : bool):
	if !AudioManager.is_paused:
		if AudioManager.PREVIOUS_SONGS.is_empty():
			return
		
		var previousSong
		if currently_playing_song:
			if fade:
				FadeOut(currently_playing_song)
			else:
				currently_playing_song.stop()
		
		AudioManager.IN_FRONT_SONGS.append(currently_playing_song)
		previousSong = AudioManager.PREVIOUS_SONGS.pop_back()
		
		currently_playing_song = previousSong
		currently_playing_song.play()
		startFadeTimer(currently_playing_song.stream.get_length())
		
		if fade:
			FadeIn(currently_playing_song)
		
		if showNotification:
			if !AudioManager.NotificationOnScreen:
				AudioManager.NotificationNode.spawnAudioNotification(AudioManager.is_paused, currently_playing_song.name)
			else:
				AudioManager.NotificationNode.updateNotification(AudioManager.is_paused, currently_playing_song.name)

# TODO
#func StartSong(song : Node, fade : bool, showNotification : bool):
#	pass

func Start(fade : bool, showNotification : bool):
	AudioManager.is_paused = false
	var nextSong
	randomize()
	while true:
		nextSong = songs[randi() % songs.size()]
		if nextSong != currently_playing_song and nextSong.name not in RESERVED_SONGS:
			break
	
	currently_playing_song = nextSong
	currently_playing_song.play()
	startFadeTimer(currently_playing_song.stream.get_length())
	
	if fade:
		FadeIn(currently_playing_song)
	
	if showNotification:
		if !AudioManager.NotificationOnScreen:
			AudioManager.NotificationNode.spawnAudioNotification(AudioManager.is_paused, currently_playing_song.name)
		else:
			AudioManager.NotificationNode.updateNotification(AudioManager.is_paused, currently_playing_song.name)

# TODO
#func Stop(song : Node, fade : bool):
#	pass

func FadeIn(song : Node):
	song.volume_db = -80
	var fadetween = get_tree().create_tween()
	fadetween.tween_property(song, "volume_db", VOLUME_DB, AudioManager.FADE_TIME)

func FadeOut(song : Node):
	var fadetween = get_tree().create_tween()
	fadetween.connect("finished", Callable(self, "FadeOutFinished").bind(song))
	fadetween.tween_property(song, "volume_db", -80, AudioManager.FADE_TIME)

func audibleOnlyFadeOut(song):
	var fadetween = get_tree().create_tween()
	fadetween.tween_property(song, "volume_db", -80, AudioManager.FADE_TIME)

func audibleOnlyFadeOutAllSongs():
	for song in songs:
		var fadetween = get_tree().create_tween()
		fadetween.tween_property(song, "volume_db", -80, 4)

func get_currently_playing_song_node():
	return currently_playing_song

func _on_songs_finished() -> void:
	Next(AudioManager.CAN_FADE, true)

func startFadeTimer(lengthOfSong : float):
	$FadeTimer.stop()
	$FadeTimer.wait_time = lengthOfSong - AudioManager.FADE_TIME
	$FadeTimer.start()

func FadeOutFinished(song):
	song.stop()

func _on_fade_timer_timeout() -> void:
	audibleOnlyFadeOut(currently_playing_song)

func _on_debounce_timer_timeout() -> void:
	canOperate = true
