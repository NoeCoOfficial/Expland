extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !OS.has_feature("debug"):
		$Notice/DebugNotice.hide()
	
	$Notice/DebugNotice.self_modulate = Color(1, 1, 1, 0)
	$Notice.self_modulate = Color(1, 1, 1, 0)
	
	await get_tree().create_timer(1).timeout
	playTextFade()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func playTextFade():
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Notice, "self_modulate", Color(1, 1, 1, 1), 0.5)
	tween.tween_property($Notice/DebugNotice, "self_modulate", Color(1, 1, 1, 1), 0.5)
	tween.tween_property($Notice, "self_modulate", Color(1, 1, 1, 0), 0.5).set_delay(4)
	tween.tween_property($Notice/DebugNotice, "self_modulate", Color(1, 1, 1, 0), 0.5).set_delay(4)
	tween.connect("finished", Callable(self, "on_fade_finished"))

func on_fade_finished():
	call_deferred("change_to_main_menu")

func change_to_main_menu() -> void:
	get_tree().change_scene_to_file("res://Scenes and Scripts/Scenes/Main Menu/MainMenu.tscn")
