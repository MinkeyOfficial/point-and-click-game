extends Interactable

@onready var player = $"../../../Player"

var is_turning_to_player = false
var is_turning_back = false
var default_rotation_y: float
var is_interacting = false

func _ready():
	default_rotation_y = rotation.y


func interact():
	print("Interacted with: ", name)
	is_turning_to_player = true
	is_turning_back = false
	is_interacting = true
	show_text(interaction_text)


func end_interaction():
	is_turning_to_player = false
	is_turning_back = true
	is_interacting = false
	print("Interaction ended with: ", name)


func _process(delta):
	# --- pokud probíhá interakce, kontroluj vzdálenost hráče ---
	if is_interacting and player:
		var dist = global_position.distance_to(player.global_position)
		if dist > disengage_distance:
			end_interaction()

	# --- rotace ---
	if is_turning_to_player:
		_turn_towards(player.global_position, delta)
	elif is_turning_back:
		_turn_back(delta)


func _turn_towards(target_pos: Vector3, delta: float):
	var to_player = (target_pos - global_position).normalized()
	to_player.y = 0

	var target_rotation = atan2(to_player.x, to_player.z) + PI
	rotation.y = lerp_angle(rotation.y, target_rotation, delta * rotation_speed)

	if abs(rotation.y - target_rotation) < 0.05:
		rotation.y = target_rotation
		is_turning_to_player = false
		if interaction_text != "":
			show_text(interaction_text)


func _turn_back(delta: float):
	rotation.y = lerp_angle(rotation.y, default_rotation_y, delta * rotation_speed)
	if abs(rotation.y - default_rotation_y) < 0.05:
		rotation.y = default_rotation_y
		is_turning_back = false


func show_text(text):
	var ui = get_tree().root.get_node("Main/UI")
	if ui:
		ui.show_interaction_text(text)
	else:
		print(text)
