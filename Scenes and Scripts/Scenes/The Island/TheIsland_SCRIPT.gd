extends Node


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _ready() -> void:
	SaveManager.loadAllData()
