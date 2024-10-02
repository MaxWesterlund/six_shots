extends CharacterBody3D

@export var move_speed: float

@export var camera_move_distance: float

@export var min_hand_distance: float
@export var max_hand_distance: float

@onready var camera = $Node/Camera3D
@onready var camera_height = camera.global_position.y
@onready var hand = $Node/Hand
@onready var hand_height = hand.global_position.y

var mouse_world_position: Vector3
var mouse_relative_position: Vector2

func _process(delta: float):
	look_rotation()
	camera_movement()
	hand_movement()
	shoot()

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
	mouse_world_position = mouse_origin - mouse_normal / mouse_normal.y * (camera_height - hand_height)
	mouse_relative_position = (Vector2(mouse_world_position.x, mouse_world_position.z) - Vector2(global_position.x, global_position.z))
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
	
	camera_movement *= 0.4

	camera.global_position = global_position + Vector3(camera_movement.x, 0, camera_movement.y)
	camera.global_position.y = camera_height

func hand_movement():
	hand.origin = global_position
	hand.target = mouse_world_position

func shoot():
	if Input.is_action_just_pressed("shoot"):
		var origin = hand.bullet_origin.global_position
		var normal = -hand.bullet_origin.global_basis.z
		GameEvents.handle_shot(get_world_3d().direct_space_state, origin, normal)
