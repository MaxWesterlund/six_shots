extends Node3D

@export var min_distance: float
@export var max_distance: float
@export var height: float

@onready var bullet_origin = $GunMesh/BulletOrigin

var origin: Vector3
var target: Vector3

func _process(delta):
	var target_difference = target - origin
	var dist = clampf(target_difference.length(), min_distance, max_distance)
	global_position = origin + Vector3(target_difference.x, 0, target_difference.z).normalized() * dist
	global_position.y = height
	rotation.y = atan2(-target_difference.z, target_difference.x) - PI / 2
