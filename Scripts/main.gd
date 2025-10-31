extends Node3D

@onready var camera = $Player/Camera3D
@onready var player = $Player

func _unhandled_input(event):
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
        var from = camera.project_ray_origin(event.position)
        var to = from + camera.project_ray_normal(event.position) * 1000.0

        var space_state = get_world_3d().direct_space_state

        var query := PhysicsRayQueryParameters3D.new()
        query.from = from
        query.to = to
        query.collide_with_areas = false
        query.collide_with_bodies = true
        query.exclude = [player]  # ať se nezasáhne vlastní kolize hráče
        # query.collision_mask = 1  # volitelné: omez na konkrétní masku (např. 'Ground')

        var result = space_state.intersect_ray(query)

        if result and result.has("position"):
            player.agent.target_position = result.position
            print("Target set to: ", result.position)
		

    

