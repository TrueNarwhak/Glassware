extends Enemy

export var jump_height = 300
export var jump_distance = 64

export var accel = 8
export var gravity = 7
export var target_fps = 60
export var air_resistance = 1
export var max_speed = 240

var motion = Vector2.ZERO
var current_speed = max_speed
var current_jump_distance = jump_distance

onready var body = $KinematicBody2D
onready var sprite = $KinematicBody2D/AnimatedSprite
onready var player = get_node("../Player")
# ---------------------------------------------- #

func _ready():
	pass

func _physics_process(delta):
	
	if body.is_on_floor(): 
		motion.x -= accel * delta * target_fps
		motion.x = clamp(motion.x, -current_speed, current_speed)
	
	if player.position.x <= body.position.x:
		sprite.flip_h = true
		current_speed = max_speed
	else:
		sprite.flip_h = false
		current_speed = -max_speed
	
	motion.y += gravity * delta * target_fps
	
	motion = body.move_and_slide(motion, Vector2.UP) 
