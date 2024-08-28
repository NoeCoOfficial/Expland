@icon("res://Textures/Icons/Script Icons/32x32/crosshair.png")
extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
