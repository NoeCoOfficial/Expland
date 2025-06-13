class_name RandomMusic extends Node

@export_group("Variables")
@export var Streams : Array[AudioStream]
@export var FadeTime : float = 2.0

@export_group("References")
@export var RandomMusicPlayer : AudioStreamPlayer
@export var Countdown : Timer
