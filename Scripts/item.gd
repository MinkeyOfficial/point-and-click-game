extends Interactable

@export var item_name: String
@export var item_icon: Texture2D

func interact():
	var data = {
		"name": item_name,
		"icon": item_icon
	}

	PlayerInventory.add_item(data)
	print("Sebral jsi: ", item_name)
	print(PlayerInventory.items)
	queue_free()
