extends Node

var SaveAndLoadThread

func _ready() -> void:
	SaveAndLoadThread = Thread.new()
