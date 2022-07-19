extends Enemy

export var jump_height = 100
export var jump_distance = 64

export var accel = 8
export var gravity = 7
export var target_fps = 60
export var air_resistance = 1
export var max_speed = 0

export var cap_speed = 100

export(PackedScene) var explode_attack

var motion = Vector2.ZERO
var current_jump_distance = jump_distance

onready var sprites = $KinematicBody2D/Sprites
onready var body = $KinematicBody2D
onready var bottle_sprite = $KinematicBody2D/Sprites/Bottle
onready var label_sprite = $KinematicBody2D/Sprites/Label
onready var cap = $KinematicBody2D/Cap
onready var jump_timer = $KinematicBody2D/JumpTimer
onready var expode_timer = $KinematicBody2D/ExplodeTimer
onready var anim = $AnimationPlayer

onready var jump_step_sfx  = $JumpStep
onready var water_drop_sfx = $WaterDrop

var jump_sounds = [
	load("res://sound/sfx/Clink/Clink1.ogg"), 
	load("res://sound/sfx/Clink/Clink2.ogg")
]

var water_drop_sounds = [
	load("res://sound/sfx/WaterDrop/WaterDrop Down.ogg"), 
	load("res://sound/sfx/WaterDrop/WaterDrop Up.ogg"), 
	load("res://sound/sfx/WaterDrop/WaterDrop.ogg")
]

var play_sound = true

# --------------------------------------------------------------- #

func _ready():
	randomize()

func _physics_process(delta):
	
	# Physics
	if !body.is_on_floor(): 
		motion.x -= accel * delta * target_fps
		motion.x = clamp(motion.x, -current_jump_distance, current_jump_distance)
		
		# Sound
		play_sound = true
	else:
		motion.x = 0
		
		# Sound
		if play_sound:
			jump_step_sfx.stream = jump_sounds[randi() % jump_sounds.size()]
			jump_step_sfx.play()
			
#			water_drop_sfx.stream = water_drop_sounds[randi() % water_drop_sounds.size()]
			
			play_sound = false
	
	
	motion.y += gravity * delta * target_fps
	
	motion = body.move_and_slide(motion, Vector2.UP) 
	
	# Move anim
	if player.get_global_position().x >= body.global_position.x:
		bottle_sprite.flip_h = true
		label_sprite.flip_h = true
		current_jump_distance = -jump_distance
	else:
		bottle_sprite.flip_h = false
		label_sprite.flip_h = false
		current_jump_distance = jump_distance
	
	# Falling Anim
	if motion.y > 0:
		bottle_sprite.play("Fall")
		label_sprite.play("Fall")
	elif motion.y < 0:
		bottle_sprite.play("Jump")
		label_sprite.play("Jump")
	
	# Explode on timeout anim
	if body.is_on_floor() and jump_timer.time_left > 0:
		bottle_sprite.play("default")
		label_sprite.play("default")
	elif !jump_timer.time_left > 0:
		bottle_sprite.play("Explode")
		label_sprite.play("Explode")
		
		cap.show()
		cap.position.y -= cap_speed
	
	
	

func _on_JumpTimer_timeout():
	if body.is_on_floor():
		motion.y = -jump_height


func _on_Hitbox_area_entered(area):
	if body.is_in_group("Player"):
		body.shatter()


func _on_ActivationArea_body_entered(body):
	if body.is_in_group("Player") and body.is_physics_processing():
		expode_timer.start()
		jump_timer.stop()
	
		bottle_sprite.play("Explode")
		label_sprite.play("Explode")
		anim.play("ExplodeShake")

func _on_ExplodeTimer_timeout():
	print("CHABOOF")
	var this_explosion = explode_attack.instance()
	this_explosion.global_transform = body.get_global_transform()
	
	get_parent().add_child(this_explosion) 
	
	queue_free()
	shatter()
