extends CharacterBody3D

@export var move_speed: float
@export var min_distance_from_player: float
@export var max_distance_from_player: float

var move_direction: Vector3

func _process(_delta):
	var player_pos = GameInfo.player_position
	var player_relative_position = player_pos - global_position
	rotation.y = atan2(-player_relative_position.z, player_relative_position.x) - PI / 2
	
	var dist = global_position.distance_to(player_pos)
	if dist < min_distance_from_player:
		move_direction = global_position - player_pos
		move_direction.y = 0
	elif dist > max_distance_from_player:
		move_direction = player_pos - global_position
		move_direction.y = 0
	else:
		move_direction = Vector3.ZERO

func _physics_process(delta):
	velocity = move_speed * delta * move_direction
	move_and_slide()

func hit():
	queue_free()
