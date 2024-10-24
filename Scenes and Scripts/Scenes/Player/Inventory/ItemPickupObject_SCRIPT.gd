# ItemPickupObject_SCRIPT.gd

extends CharacterBody3D

@export var ITEM_TYPE: String:
	set(value):
		ITEM_TYPE = value
		PATH_TO_OBJECT = "res://Assets/3D Models/Inventory Pickup Items/" + ITEM_TYPE + ".blend"
	get:
		return ITEM_TYPE

var PATH_TO_OBJECT: String

# Called when the node enters the scene tree for the first time.
func _ready():
	self.global_position = get_node("/root/World/Player").global_position
	self.global_position.y += 1.5
	ITEM_TYPE = InventoryManager.item_ref
	PlayBobbingAnimation()
	PlaySpinningAnimation()
	var LOADED_OBJECT = load(PATH_TO_OBJECT)
	if LOADED_OBJECT == null:
		print("Failed to load object: ", PATH_TO_OBJECT)
	else:
		print("Object loaded successfully!")
		var INSTANTIATED_OBJECT = LOADED_OBJECT.instantiate()
		self.add_child(INSTANTIATED_OBJECT)

func _physics_process(delta):
	# Apply gravity
	self.velocity.y -= 12.0 * delta
	move_and_slide()

func PlaySpinningAnimation():
	var tween = get_tree().create_tween()
	var current_rotation_y = self.rotation.y
	var final_rotation_y = current_rotation_y + 2 * PI  # Rotate 360 degrees
	tween.tween_property(self, "rotation:y", final_rotation_y, 3)
	tween.connect("finished", Callable(self, "_on_spinning_anim_finished"))

func _on_spinning_anim_finished():
	# Reset rotation to avoid floating-point precision issues
	self.rotation.y = fmod(self.rotation.y, 2 * PI)
	PlaySpinningAnimation()

func PlayBobbingAnimation():
	var tween = get_tree().create_tween()
	var default_y = self.position.y
	var final_y_top = default_y + 0.2
	var time = 1.3
	tween.tween_property(self, "position:y", final_y_top, time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:y", default_y, time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
