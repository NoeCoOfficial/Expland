extends CharacterBody3D

## SLOT MUST BE BETWEEN 1 AND 9
## ITEM MUST BE A VALID ITEM (FOR EXAMPLE: "APPLE")
func PopulateInventorySlot(Slot : int, Item : String):

	## This is where we define all of the items in the game.

	if Slot == 1: # Check if the slot is 1

		match Item:
			"APPLE":
				$PathToSlot_1.texture = InventoryManager.TEXTURE_APPLE # Define variables with the name of the item after "TEXTURE_"

	elif Slot == 2: # Check if the slot is 1

		match Item:
			"APPLE":
				$PathToSlot_1.texture = InventoryManager.TEXTURE_APPLE # Define variables with the name of the item after "TEXTURE_"
	elif Slot == 3: # Check if the slot is 2
		pass
	elif Slot == 4: # Check if the slot is 3
		pass
	elif Slot == 5: # Check if the slot is 4
		pass
	elif Slot == 6: # Check if the slot is 5
		pass
	elif Slot == 7: # Check if the slot is 6
		pass
	elif Slot == 8: # Check if the slot is 7
		pass
	elif Slot == 9: # Check if the slot is 8
		pass

