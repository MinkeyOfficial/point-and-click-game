extends CharacterBody3D

@onready var agent = $NavigationAgent3D
@onready var animation = $model_paesant/AnimationPlayer
@onready var model = $model_paesant

var move_speed = 5.0
var target_position = Vector3.ZERO
var turn_speed = 8.0 # větší = rychlejší otáčení

func _ready():
	target_position = global_position
	agent.target_position = target_position

func _physics_process(_delta):
	if agent.is_navigation_finished():
		velocity = Vector3.ZERO
		animation.play("AnimPack1/idle")
		move_and_slide()
		return

	var next_point = agent.get_next_path_position()
	var direction = (next_point - global_position).normalized()
	velocity = direction * move_speed
	if direction.length() > 0:
		animation.play("AnimPack1/walk")

		# plynulé otočení modelu směrem k další cestovní poloze (XZ rovina)
		var target_dir = next_point - global_position
		target_dir.y = 0
		if target_dir.length() > 0.001:
			var desired_yaw = atan2(target_dir.x, target_dir.z)
			var current_yaw = model.rotation.y
			model.rotation.y = lerp_angle(current_yaw, desired_yaw, turn_speed * _delta)
	else:
		animation.play("AnimPack1/idle")

	move_and_slide()
