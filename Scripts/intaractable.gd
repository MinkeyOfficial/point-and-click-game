extends Area3D
class_name Interactable

@export var interaction_text: String = ""
@export var interaction_distance: float = 1.5

func interact():
	print("Interacted with: ", name)
	if interaction_text != "":
		show_text(interaction_text)

func show_text(text):
	var ui = get_tree().root.get_node("Main/UI") # přizpůsob podle tvé scény
	if ui:
		ui.show_interaction_text(text)
	else:
		print(text)
