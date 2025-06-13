class_name RandomMusic extends Node

@export_group("Variables")
@export var Streams : Array[AudioStream] ## The streams you want to play.
@export var FadeInTime : float = 2.0 ## How long it takes to fade in to a song.
@export var FadeOutTime : float = 2.0 ## How long it takes to fade out a song.
@export var LowerBoundRandomSec : float = 400.0 ## After a song finishes, a new song will start after at least this many seconds.
@export var UpperBoundRandomSec : float = 1000.0 ## After a song finishes, a new song will start after at most this many seconds.

@export_group("References")
@export var RandomMusicPlayer : AudioStreamPlayer
@export var Countdown : Timer
