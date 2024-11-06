extends CharacterBody3D

var gravity = 12.0
var Item

@export var ITEM_TYPE: String:
	set(value):
		ITEM_TYPE = value
		PATH_TO_OBJECT = "res://Assets/3D Models/Inventory Pickup Items/" + ITEM_TYPE + ".blend"
	get:
		return ITEM_TYPE

var PATH_TO_OBJECT: String
var instantiated_object # Variable to hold the reference to the instantiated object

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	move_and_slide()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.global_position = get_node("/root/World/Player/Head/ItemDropPosition").global_position
	ITEM_TYPE = InventoryManager.item_ref
	var LOADED_OBJECT = load(PATH_TO_OBJECT)
	# null checks
	if LOADED_OBJECT == null:
		print("Failed to load object: ", PATH_TO_OBJECT)
	else:
		print("Object loaded successfully! Path: " + PATH_TO_OBJECT)
		
		instantiated_object = LOADED_OBJECT.instantiate() # create an instance of the object
		self.add_child(instantiated_object) # add it to the scene
		PlayBobbingAnimation()
		PlaySpinningAnimation()

func PlaySpinningAnimation():
	var tween = get_tree().create_tween()
	var current_rotation_y = instantiated_object.rotation.y
	var final_rotation_y = current_rotation_y + 2 * PI  # Rotate 360 degrees
	tween.tween_property(instantiated_object, "rotation:y", final_rotation_y, 3)
	tween.connect("finished", Callable(self, "_on_spinning_anim_finished"))

func _on_spinning_anim_finished():
	# Reset rotation to avoid floating-point precision issues
	instantiated_object.rotation.y = fmod(instantiated_object.rotation.y, 2 * PI)
	PlaySpinningAnimation()

func PlayBobbingAnimation():
	var tween = get_tree().create_tween()
	var default_y = instantiated_object.position.y
	var final_y_top = default_y + 1.5
	var time = 1.3
	tween.tween_property(instantiated_object, "position:y", final_y_top, time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(instantiated_object, "position:y", default_y, time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.connect("finished", Callable(self, "_on_bobbing_anim_finished"))

func _on_bobbing_anim_finished():
	PlayBobbingAnimation()
