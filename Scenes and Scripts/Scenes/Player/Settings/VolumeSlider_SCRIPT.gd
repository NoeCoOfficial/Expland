extends HSlider

@export var bus_name :String

var bus_index : int

# Called when the node enters the scene tree for the first time.
func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	if bus_name == "Master":
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(PlayerSettingsData.Master_Volume))
	elif bus_name == "sfx":
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(PlayerSettingsData.sfx_Volume))
	elif bus_name == "music":
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(PlayerSettingsData.music_Volume))
	
	value_changed.connect(_on_changed)

	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_changed(Slidervalue:float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(Slidervalue))
	
	if bus_name == "Master":
		PlayerSettingsData.Master_Volume = Slidervalue
	elif bus_name == "sfx":
		PlayerSettingsData.sfx_Volume = Slidervalue
	elif bus_name == "music":
		PlayerSettingsData.music_Volume = Slidervalue
	
