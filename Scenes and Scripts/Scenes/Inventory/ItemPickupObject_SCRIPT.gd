extends Node3D

@export var ITEM_TYPE: String
var PATH_TO_OBJECT: String = "res://Textures/Inventory/" + ITEM_TYPE + ".blend"

# Called when the node enters the scene tree for the first time.
func _ready():
	var LOADED_OBJECT = load(PATH_TO_OBJECT)
	if LOADED_OBJECT == null:
		print("Failed to load texture: ", PATH_TO_OBJECT)
	else:
		print("Texture loaded successfully!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
