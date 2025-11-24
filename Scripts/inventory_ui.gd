extends Control

@onready var container = $Container

func _ready():
	update_inventory()
	PlayerInventory.connect("items_changed", Callable(self, "update_inventory"))

func update_inventory():
	for child in container.get_children():
		child.queue_free()
	print("UI UPDATING…")

	for item in PlayerInventory.items:
		var label = Label.new()
		label.text = item.name
		container.add_child(label)
