extends StaticBody3D

enum Direction {FORWARD, BACKWARD, UP, DOWN, LEFT, RIGHT}

var directions = []
const MAX_DIRECTIONS = 3

func shoot():
	return

func move_and_rotate(delta, direction: Array, hard=false, speed=0):
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

	var multiplier = speed * delta

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
			Direction.DOWN:
				heave = -1
			Direction.LEFT:
				sway = -1
			Direction.RIGHT:
				sway = 1

	surge *= multiplier
	heave *= multiplier
	sway *= multiplier

	position += Vector3(surge,heave,sway)
	#rotation += Vector3(0,0,0.5*delta)
	return

func _init():
	print("Initializing ships...")
	seed(12345)
	for i in range(MAX_DIRECTIONS):
		directions.append(0)

func _process(delta):
	for i in range(MAX_DIRECTIONS):
		directions[i] = randi() % len(Direction)
	print(directions)
	move_and_rotate(delta, directions, false, 1)
	return
