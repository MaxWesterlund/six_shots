extends CharacterBody3D

@export var move_speed: float

@export var camera_move_distance: float

@export var min_hand_distance: float
@export var max_hand_distance: float

@onready var camera = $Node/Camera3D
@onready var camera_height = camera.global_position.y
@onready var hand = $Node/Hand
@onready var hand_height = hand.global_position.y

var mouse_relative_position: Vector2

func _process(delta: float):
	look_rotation()
	camera_movement()
	hand_movement()

func _physics_process(delta: float):
	movement(delta)

func movement(delta: float):
	var move_vec: Vector3
	if Input.is_action_pressed("move_up"):
		move_vec.z -= 1
	if Input.is_action_pressed("move_down"):
		move_vec.z += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	move_vec = move_vec.normalized()
	
	velocity = move_speed * delta * move_vec
	move_and_slide()

func look_rotation():
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var mouse_origin = camera.project_ray_origin(mouse_pos)
	var mouse_normal = camera.project_ray_normal(mouse_pos)
	var mouse_world_pos = mouse_origin - mouse_normal / mouse_normal.y * (camera_height - hand_height)
	mouse_relative_position = (Vector2(mouse_world_pos.x, mouse_world_pos.z) - Vector2(global_position.x, global_position.z))
	var normal_rel_pos = mouse_relative_position.normalized()
	var target = atan2(-normal_rel_pos.y, normal_rel_pos.x) - PI / 2
	rotation.y = target

func camera_movement():
	var camera_movement: Vector2
	var mouse_dist = mouse_relative_position.length()
	if mouse_dist > camera_move_distance:
		camera_movement = mouse_relative_position.normalized() * camera_move_distance
	else:
		camera_movement = mouse_relative_position
	
	camera_movement *= 0.5

	camera.global_position = global_position + Vector3(camera_movement.x, 0, camera_movement.y)
	camera.global_position.y = camera_height

func hand_movement():
	var lerp = clampf(mouse_relative_position.length(), 0, 1)
	var distance = lerp(min_hand_distance, max_hand_distance, lerp)
	hand.global_position = global_position + Vector3(mouse_relative_position.x, 0, mouse_relative_position.y).normalized() * distance
	hand.global_position.y = hand_height
	hand.rotation.y = atan2(-mouse_relative_position.y, mouse_relative_position.x) - PI / 2
