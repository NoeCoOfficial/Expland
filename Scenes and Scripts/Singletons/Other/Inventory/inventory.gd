extends PanelContainer


const Slot = preload("res://Scenes and Scripts/Singletons/Other/Inventory/slot.tscn")

@onready var item_grid = $MarginContainer/ItemGrid

func _ready() -> void:
	var inv_data = preload("res://Scenes and Scripts/Singletons/Other/Inventory/test_inv.tres")
	populate_item_grid(inv_data.slot_datas)
func populate_item_grid(slot_datas: Array[SlotData]) -> void:
	for child in item_grid.get_children():
		child.queue_free()
		
		for slot_data in slot_datas:
			var slot = Slot.instantiate()
			item_grid.add_child(slot)
