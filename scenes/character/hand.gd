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
	position = Vector3.FORWARD * dist
	position.y = height
