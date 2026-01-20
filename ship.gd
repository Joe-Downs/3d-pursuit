extends StaticBody3D

enum Direction {FORWARD, BACKWARD, UP, DOWN, LEFT, RIGHT}

var destination := Vector3()
var directions = []
const MAX_DIRECTIONS = 3

func shoot():
	return

func move_and_rotate(delta, direction: Array, hard=false, change=false, speed=0):
	# We want to steer in the following directions, each with "HARD" variants:
	# - UP
	# - DOWN
	# - LEFT
	# - RIGHT

	# Forward/Backward
	var surge = 0
	# Left/Right
	var sway = 0
	# Up/Down
	var heave = 0

	var roll = 0
	var pitch = 0
	var yaw = 0

	var multiplier = speed * delta
	var rotation_mult = speed * delta * 5

	if hard:
		multiplier *= 10

	for d in direction:
		match d:
			Direction.FORWARD:
				surge = 1
			Direction.BACKWARD:
				surge = -1
			Direction.UP:
				heave = 1
				pitch = 1
			Direction.DOWN:
				heave = -1
				pitch = -1
			Direction.LEFT:
				sway = -1
				yaw = 1
			Direction.RIGHT:
				sway = 1
				yaw = -1

	surge *= multiplier
	heave *= multiplier
	sway *= multiplier

	# if !change:
	# 	rotation_mult = 0

	pitch = deg_to_rad(pitch * rotation_mult)
	yaw = deg_to_rad(yaw * rotation_mult)
	roll = deg_to_rad(roll * rotation_mult)

	position += Vector3(surge, heave, sway)
	rotation += Vector3(roll, yaw, pitch)
	return

func _check_coord_distance(src: Vector3, dest: Vector3, margin: float = 5.0) -> bool:
	# Check if two coords are within some margin of each other
	if abs(src.distance_to(dest)) <= margin:
		print("Close enough to the destination!")
		return true
	else:
		return false

func _rand_coord() -> int:
	return randi() % 100

func choose_point() -> Vector3:
	# Choose some point away from the ship and navigate there
	var dest := Vector3()
	dest.x = _rand_coord()
	dest.y = _rand_coord()
	dest.z = _rand_coord()
	return dest

func _init():
	print("Initializing ships...")
	seed(12345)
	for i in range(MAX_DIRECTIONS):
		directions.append(Direction.FORWARD)

func _process(delta):
	var change = false
	#print("Current position: %s" % position)
	if _check_coord_distance(position, destination):
		destination = choose_point()
		print("Desired Position: %s" % destination)
	# Chance to change direction
	if !(randi() % 250):
		change = true
		print("Changing directions")
		destination = choose_point()
	#move_and_rotate(delta, directions, false, change, 1)
	position = position.lerp(destination, delta*2)
	return
