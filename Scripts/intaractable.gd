extends Area3D
class_name Interactable

@export var interaction_text: String = ""
@export var interaction_distance: float = 1.5
@export var rotation_speed: float = 5.0
@export var disengage_distance: float = 3.0  # po jaké vzdálenosti se interakce ukončí

func interact():
	print("Interacted with: ", name)
	show_text(interaction_text)

func show_text(text):
	var ui = get_tree().root.get_node("Main/UI")
	if ui:
		ui.show_interaction_text(text)
	else:
		print(text)
