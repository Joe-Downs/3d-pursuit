extends StaticBody3D

enum Direction {FORWARD, BACKWARD, UP, DOWN, LEFT, RIGHT}

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

func _init():
	print("Initializing ships...")
	seed(12345)
	# directions.append(Direction.FORWARD)
	# directions.append(Direction.LEFT)
	for i in range(MAX_DIRECTIONS):
		directions.append(Direction.FORWARD)

func _process(delta):
	var change = false
	# Chance to change direction
	if !(randi() % 250):
		change = true
		for i in range(MAX_DIRECTIONS):
			directions[i] = randi() % len(Direction)
		print("Changing directions")
		print(directions)
	move_and_rotate(delta, directions, false, change, 1)
	return
