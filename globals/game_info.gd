extends Node

var player_position: Vector3

func handle_shot(space_state: PhysicsDirectSpaceState3D, origin: Vector3, normal: Vector3):
	var query = PhysicsRayQueryParameters3D.create(origin, origin + normal * 1000)
	var result = space_state.intersect_ray(query)
	if result:
		result.collider.hit()
