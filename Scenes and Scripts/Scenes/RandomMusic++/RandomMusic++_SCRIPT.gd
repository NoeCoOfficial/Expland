@tool
extends Node

@export_group("Variables")
@export var Streams : Array[AudioStream]
@export var FadeInTime : float = 2.0
@export var FadeOutTime : float = 2.0
@export var DefaultDB : float = 0.0
@export var SilentDB : float = -60.0
@export var LowerBoundRandomSec : float = 400.0
@export var UpperBoundRandomSec : float = 1000.0

@export_group("References")
@export var RandomMusicPlayer : AudioStreamPlayer
@export var Countdown : Timer

var currently_playing_stream : AudioStream

func _ready() -> void:
	name = "RandomMusic++"
	if !Engine.is_editor_hint():
		randomize()

func start(fade_In : bool = true):
	var next_stream = getRandomSong()
	if next_stream and RandomMusicPlayer:
		currently_playing_stream = next_stream
		RandomMusicPlayer.stream = currently_playing_stream
		RandomMusicPlayer.play()
		if fade_In:
			fadeIn(next_stream)
		else:
			RandomMusicPlayer.volume_db = DefaultDB
	elif not RandomMusicPlayer:
		push_warning("RandomMusicPlayer node not found!")

func stop(fade_Out : bool = true):
	if RandomMusicPlayer:
		if fade_Out and RandomMusicPlayer.playing:
			fadeOut(currently_playing_stream)
			await get_tree().create_timer(FadeOutTime).timeout
			RandomMusicPlayer.stop()
		else:
			RandomMusicPlayer.stop()
	else:
		push_warning("RandomMusicPlayer node not found!")

func getRandomSong(avoid_repeats: bool = true) -> AudioStream:
	if Streams.is_empty():
		return null
	var available_streams = Streams.duplicate()
	if avoid_repeats and currently_playing_stream and available_streams.has(currently_playing_stream) and available_streams.size() > 1:
		available_streams.erase(currently_playing_stream)
	var idx = randi() % available_streams.size()
	return available_streams[idx]

func fadeIn(stream : AudioStream):
	if stream and RandomMusicPlayer:
		RandomMusicPlayer.volume_db = SilentDB
		var tween = get_tree().create_tween()
		tween.tween_property(RandomMusicPlayer, "volume_db", DefaultDB, FadeInTime)

func fadeOut(stream : AudioStream):
	if stream and RandomMusicPlayer:
		var tween = get_tree().create_tween()
		tween.tween_property(RandomMusicPlayer, "volume_db", SilentDB, FadeOutTime)

func _on_random_music_player_finished() -> void:
	var wait_time = randf_range(LowerBoundRandomSec, UpperBoundRandomSec)
	Countdown.wait_time = wait_time
	Countdown.one_shot = true
	Countdown.start()

func _on_countdown_timeout() -> void:
	start(true)
