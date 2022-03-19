extends Enemy
class_name Plate

export var accel = 8
export var gravity = 7
export var target_fps = 60
export var air_resistance = 1
export var max_speed = 500

var motion = Vector2.ZERO
var current_dir = 1

onready var body = $KinematicBody2D
onready var eyes = $KinematicBody2D/Eyes
onready var plate = $KinematicBody2D/Plate
onready var left_pos = $KinematicBody2D/LeftPos
onready var right_pos = $KinematicBody2D/RightPos

var bumped_eyes = preload("res://images/enemies/Plate/Asset 62.png") 
var normal_eyes = preload("res://images/enemies/Plate/Asset 61.png") 

# ------------------------------------------- #

func _ready():
	pass

func _physics_process(delta):
	
	# Physics
	if body.is_on_floor():
		motion.x +=  accel * current_dir * delta * target_fps
		motion.x = clamp(motion.x, -max_speed, max_speed)
		
		eyes.texture = normal_eyes
	else: 
		eyes.texture = bumped_eyes
	
	if player.get_global_position().x >= body.global_position.x:
		current_dir = 1
	else:
		current_dir = -1
	
	# Animation
	plate.rotation_degrees += accel * current_dir * delta * target_fps / 2
	
#	eyes.position.x = lerp(eyes.position.x, player.position.x, 0.8)
	eyes.position.x = player.get_global_position().x
	eyes.position.x = clamp(eyes.position.x, right_pos.position.x, left_pos.position.x)
	
#	print(player.position.x >= body.position.x)
#	print("body: " + str(body.position.x))
#	print("player: " + str(player.position.x))
	
	motion.y += gravity * delta * target_fps
	
	motion = body.move_and_slide(motion, Vector2.UP) 


func _on_Hitbox_body_entered(body):
	if body.is_in_group("Player"):
		body.shatter()
