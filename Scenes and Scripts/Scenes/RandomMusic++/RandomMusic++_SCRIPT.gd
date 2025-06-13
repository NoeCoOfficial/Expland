class_name RandomMusic extends Node

@export_group("Variables")
@export var Streams : Array[AudioStream] ## The streams you want to play.
@export var FadeInTime : float = 2.0 ## How long it takes to fade in to a song.
@export var FadeOutTime : float = 2.0 ## How long it takes to fade out a song.
@export var DefaultDB : float = 0.0 ## The default volume for the audio streams (in decibels)
@export var SilentDB : float = -60.0 ## The value in decibels to fade in from/out to
@export var LowerBoundRandomSec : float = 400.0 ## After a song finishes, a new song will start after at least this many seconds.
@export var UpperBoundRandomSec : float = 1000.0 ## After a song finishes, a new song will start after at most this many seconds.

@export_group("References")
@export var RandomMusicPlayer : AudioStreamPlayer
@export var Countdown : Timer

func start():
	pass

func fadeIn(stream : AudioStream):
	if stream:
		stream.volume_db = SilentDB
		var tween = get_tree().create_tween()
		tween.tween_property(stream, "volume_db", DefaultDB, FadeInTime)

func fadeOut(stream : AudioStream):
	if stream:
		var tween = get_tree().create_tween()
		tween.tween_property(stream, "volume_db", SilentDB, FadeOutTime)
