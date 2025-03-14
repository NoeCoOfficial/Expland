@tool
extends Control

var time: float = 0

@onready var time_label: Label = %TimeLabel
@onready var timer: Timer = %Timer

func _process(delta: float) -> void:
	timer.time_left

func _on_timer_timeout() -> void:
	time += 0.1
	var _time: int = time
	var h: int = _time / 3_600
	var m: int = (_time % 3_600) / 60
	var s: int = (_time % 3_600) % 60
	time_label.text = "%02d:%02d:%02d" % [h, m, s]
	timer.paused = true
