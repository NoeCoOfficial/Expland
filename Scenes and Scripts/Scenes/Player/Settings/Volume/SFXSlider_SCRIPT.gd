extends VSlider

@onready var index = AudioServer.get_bus_index("sfx")

# Called when the node enters the scene tree for the first time.
func _ready():
	value = PlayerSettingsData.sfx_Volume
	AudioServer.set_bus_volume_db(index, linear_to_db(PlayerSettingsData.sfx_Volume))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	AudioServer.set_bus_volume_db(index, linear_to_db(value))
	PlayerSettingsData.sfx_Volume = value
	
