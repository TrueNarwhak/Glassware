extends Enemy

export var jump_height = 200
export var jump_distance = 200

export var accel = 8
export var gravity = 7
export var target_fps = 60
export var air_resistance = 1
export var max_speed = 0

var motion = Vector2.ZERO
var current_jump_distance = jump_distance

onready var body = $KinematicBody2D
onready var sprite = $KinematicBody2D/AnimatedSprite

onready var jump_step_sfx = $JumpStep

# --------------------------------------------- #

var jump_sounds = [
	load("res://sound/sfx/Impact Medium/impactWood_medium_000.ogg"), 
	load("res://sound/sfx/Impact Medium/impactWood_medium_001.ogg"), 
	load("res://sound/sfx/Impact Medium/impactWood_medium_002.ogg"), 
	load("res://sound/sfx/Impact Medium/impactWood_medium_003.ogg"), 
	load("res://sound/sfx/Impact Medium/impactWood_medium_004.ogg")
]

var play_sound = true

# --------------------------------------------- #

func _ready():
	randomize()
	

func _physics_process(delta):
	
	# Physicis
	if !body.is_on_floor(): 
		motion.x -= accel * delta * target_fps
		motion.x = clamp(motion.x, -current_jump_distance, current_jump_distance)
		
		sprite.playing = true
		sprite.play("Hop")
		
		# Sound
		play_sound = true
	else:
		motion.x = 0
		sprite.play("default")
		
		# Sound
		if play_sound:
			jump_step_sfx.stream = jump_sounds[randi() % jump_sounds.size()]
			jump_step_sfx.play()
			
			play_sound = false
		
	motion.y += gravity * delta * target_fps
	
	motion = body.move_and_slide(motion, Vector2.UP) 
	
	# Face Player
	if player == null or player.get_global_position().x >= body.global_position.x:
		sprite.flip_h = true
		current_jump_distance = -jump_distance
	else:
		sprite.flip_h = false
		current_jump_distance = jump_distance

func _on_Timer_timeout():
	if body.is_on_floor():
		motion.y = -jump_height
		


func _on_Hitbox_body_entered(body):
	if body.is_in_group("Player"):
		body.shatter()
