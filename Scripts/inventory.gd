extends Node
class_name Inventory

signal items_changed

var items: Array = []   # sem se budou přidávat věci

func add_item(item_data):
	items.append(item_data)
	print("Přidáno do inventáře: ", item_data.name)
	emit_signal("items_changed")

func has_item(item_name: String) -> bool:
	return items.any(func(item): return item["name"] == item_name)
