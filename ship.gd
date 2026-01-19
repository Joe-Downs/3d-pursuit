extends StaticBody3D

var speed = 400
var angular_speed = PI

func _init():
	print("Initializing ships...")

func _process(delta):
	#rotation += angular_speed * delta
#
	#var velocity = Vector3.UP.rotated(rotation, 15) * speed

	position += Vector3(5*delta,0,0)
