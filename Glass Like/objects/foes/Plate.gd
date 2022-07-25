extends Enemy
class_name Plate

export var accel = 8
export var gravity = 7
export var target_fps = 60
export var air_resistance = 1
export var max_speed = 680
#export var max_speed = 200

var motion = Vector2.ZERO
var current_dir = 1
var current_speed = 0
var skidding = false

onready var body = $KinematicBody2D
onready var eyes = $KinematicBody2D/Eyes
onready var plate = $KinematicBody2D/Plate
onready var left_pos = $KinematicBody2D/LeftPos
onready var right_pos = $KinematicBody2D/RightPos
onready var top_pos = $KinematicBody2D/TopPos
onready var bottom_pos = $KinematicBody2D/BottomPos

onready var rolling_sfx = $Roll
onready var reverse_sfx = $Reverse

var bumped_eyes = preload("res://images/enemies/Plate/Asset 62.png") 
var normal_eyes = preload("res://images/enemies/Plate/Asset 61.png") 

# ------------------------------------------- #

func _ready():
	pass

func _physics_process(delta):
	
	# Physics
	if body.is_on_floor():
		current_speed += accel * current_dir * delta * target_fps
		
	else:
		
		# Sound 
		rolling_sfx.stop()
		reverse_sfx.stop()
	
	current_speed = clamp(current_speed, -max_speed, max_speed)
	
	# Skidding
	if (current_dir < 0 and current_speed < 0) or (current_dir > 0 and current_speed > 0):
		skidding = false
	else:
		skidding = true
	
	# Apply
	motion.x = current_speed
	
	# Animation
	plate.rotation_degrees += current_speed / 100
	
	eyes.global_position.x = player.get_global_position().x
	eyes.global_position.x = clamp(eyes.global_position.x, left_pos.get_global_position().x, right_pos.get_global_position().x)
	
	# Change pos
	if player.get_global_position().x >= body.global_position.x:
		current_dir = 1
	else:
		current_dir = -1
	
	
	# Sound
	if !skidding:
		reverse_sfx.stop()
		
		if !rolling_sfx.playing and body.is_on_floor():
			rolling_sfx.play()
	else:
		rolling_sfx.stop()
		
		if !reverse_sfx.playing and body.is_on_floor():
			reverse_sfx.play()
	
	# Apply
	motion.y += gravity * delta * target_fps
	
	motion = body.move_and_slide(motion, Vector2.UP) 


func _on_Hitbox_body_entered(body):
	if body.is_in_group("Player"):
		body.shatter()
