class_name Ship
extends Area3D

# ================================== Variables =================================
@export var ENEMY: Node
@export var SPEED: int = 1
static var MAX_DIRECTIONS = 3
var destination := Vector3()
var explosion: MeshInstance3D
var explosion_material: StandardMaterial3D
var explode_speed: float= 0.3
var hit: bool = false
var destroyed: bool = false

enum Direction {FORWARD, BACKWARD, UP, DOWN, LEFT, RIGHT}

# =================================== Methods ==================================
func explode(delta):
	destroyed = true
	explosion.scale = lerp(explosion.scale, Vector3(50,50,50), delta / explode_speed)
	explosion_material.albedo_color = lerp(explosion_material.albedo_color, Color.from_rgba8(255,10,10,255), delta / explode_speed)
	explosion_material.emission = lerp(explosion_material.emission, Color.from_rgba8(255,10,10,255), delta / explode_speed)
	explosion_material.emission_energy_multiplier = lerp(explosion_material.emission_energy_multiplier, 0.0, delta / explode_speed)
	return

func shoot(target: Vector3) -> bool:
	# if enemy in self.laser:
	#    enemy.blowup()
	var laser = get_node("./Laser")
	if ENEMY in laser.get_overlapping_areas():
		print("BOOM! %s has been hit." % self.name)
		ENEMY.destroyed = true
		return true
	return false

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

func _check_coord_distance(src: Vector3, dest: Vector3, margin: float = 1.0) -> bool:
	# Check if two coords are within some margin of each other
	if abs(src.distance_to(dest)) <= margin:
		print("Close enough to the destination!")
		return true
	else:
		return false

func _rand_coord() -> int:
	# TODO: this needs to be something like [-100,100]. Right now, it's only
	# [0,100].
	return randi() % 100

func _rand_point() -> Vector3:
	var point := Vector3()
	point.x = _rand_coord()
	point.z = _rand_coord()
	point.y = _rand_coord()
	return point

func choose_point() -> Vector3:
	# Choose some point away from the ship and navigate there
	return ENEMY.position - Vector3(0,0,15)

func _init():
	print("Initializing ships...")
	seed(12345)
	explosion = MeshInstance3D.new()
	explosion.set_mesh(SphereMesh.new())
	explosion_material = StandardMaterial3D.new()
	var start_color: Color = Color.from_rgba8(255, 183, 66, 255)
	explosion_material.albedo_color = start_color
	explosion_material.emission = start_color
	explosion_material.emission_enabled = true
	explosion.mesh.surface_set_material(0, explosion_material)
	add_child(explosion)
	return

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
		destination = _rand_point()
		#move_and_rotate(delta, directions, false, change, 1)

	if !hit and !destroyed:
		position = position.lerp(destination, delta * SPEED)
		self.look_at(destination, Vector3.UP, true)
		#hit = shoot(ENEMY.position)

	if destroyed:
		explode(delta)
	return
