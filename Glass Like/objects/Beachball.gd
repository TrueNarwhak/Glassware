extends RigidBody2D

export var GRAVITY = 21
export var TARGET_FPS = 60
export var speed = Vector2(1600.0, 1600.0)
export var ball_force = 1000

var motion = Vector2(0.0, 0.0)


func _ready():
	add_force(get_local_mouse_position().normalized(), speed)

func _process(delta):
	pass

func _physics_process(delta):
#	motion = ball_force * get_local_mouse_position().normalized()
#
#	motion.y += GRAVITY * delta * TARGET_FPS
	pass

func _on_Area2D_body_entered(body):
	var this_body = body.get_parent()
	
	if this_body.is_in_group("Enemies"):
		this_body.survive -= 1
