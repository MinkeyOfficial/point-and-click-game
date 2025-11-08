extends CharacterBody3D

@onready var agent: NavigationAgent3D = $NavigationAgent3D
@onready var animation: AnimationPlayer = $model_paesant/AnimationPlayer
@onready var model: Node3D = $model_paesant

var move_speed := 5.0
var turn_speed := 8.0

var target_position := Vector3.ZERO
var target_interactable: Interactable = null
var is_moving_to_interact := false


func _ready() -> void:
	target_position = global_position
	agent.target_position = target_position


func set_target_position(pos: Vector3) -> void:
	# Kliknutí na zem → zruší interakci a hráč se pohne tam
	target_interactable = null
	is_moving_to_interact = false
	target_position = pos
	agent.target_position = pos


func set_target_interaction(obj: Interactable) -> void:
	# Kliknutí na objekt → hráč k němu dojde
	target_interactable = obj
	is_moving_to_interact = true

	var dir := (obj.global_position - global_position)
	if dir.length() < 0.1:
		dir = Vector3.FORWARD
	dir = dir.normalized()

	# Cíl před objektem – hráč se zastaví kousek před ním
	var stop_pos := obj.global_position - dir * obj.interaction_distance
	target_position = stop_pos
	agent.target_position = stop_pos


func _physics_process(delta: float) -> void:
	var dist_to_target := global_position.distance_to(target_position)
	var dist_to_obj := 0.0
	
	if target_interactable:
		dist_to_obj = global_position.distance_to(target_interactable.global_position)
		# Debug výpis (můžeš vypnout později)
		#print("Distance:", "%.2f" % dist_to_obj, " | Range:", target_interactable.interaction_distance, " | MovingToInteract:", is_moving_to_interact)

	# --- INTERAKCE ---
	if is_moving_to_interact and target_interactable and dist_to_obj <= target_interactable.interaction_distance + 0.5:
		print(">>> Interacting with", target_interactable.name)
		target_interactable.interact()
		
		is_moving_to_interact = false
		target_interactable = null
		
		target_position = global_position
		agent.target_position = global_position
		
		velocity = Vector3.ZERO
		animation.play("AnimPack1/idle")
		move_and_slide()
		return

	# --- POHYB BEZ INTERAKCE ---
	if not target_interactable and dist_to_target < 0.2:
		velocity = Vector3.ZERO
		animation.play("AnimPack1/idle")
		move_and_slide()
		return

	# --- POHYB PODLE NAVIGACE ---
	if not agent.is_navigation_finished():
		var next_point := agent.get_next_path_position()
		var direction := (next_point - global_position).normalized()
		velocity = direction * move_speed

		if direction.length() > 0:
			animation.play("AnimPack1/walk")
			_rotate_toward(next_point, delta)
	else:
		velocity = Vector3.ZERO
		animation.play("AnimPack1/idle")

	move_and_slide()


func _rotate_toward(point: Vector3, delta: float) -> void:
	var target_dir := point - global_position
	target_dir.y = 0
	
	if target_dir.length() > 0.001:
		var desired_yaw := atan2(target_dir.x, target_dir.z)
		model.rotation.y = lerp_angle(model.rotation.y, desired_yaw, turn_speed * delta)
