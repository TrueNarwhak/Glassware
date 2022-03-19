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

onready var body = $KinematicBody2D
onready var bottle_sprite = $KinematicBody2D/Sprites/Bottle
onready var label_sprite = $KinematicBody2D/Sprites/Label
onready var cap = $KinematicBody2D/Cap
# --------------------------------------------------------------- #

func _ready():
	pass

func _physics_process(delta):

	if !body.is_on_floor(): 
		motion.x -= accel * delta * target_fps
		motion.x = clamp(motion.x, -current_jump_distance, current_jump_distance)
	
	else:
		motion.x = 0
	
	
	motion.y += gravity * delta * target_fps
	
	motion = body.move_and_slide(motion, Vector2.UP) 
	
	if player.get_global_position().x >= body.global_position.x:
		bottle_sprite.flip_h = true
		label_sprite.flip_h = true
		current_jump_distance = -jump_distance
	else:
		bottle_sprite.flip_h = false
		label_sprite.flip_h = false
		current_jump_distance = jump_distance
	
	if motion.y > 0:
		bottle_sprite.play("Fall")
		label_sprite.play("Fall")
	elif motion.y < 0:
		bottle_sprite.play("Jump")
		label_sprite.play("Jump")
	
	if body.is_on_floor() and $KinematicBody2D/JumpTimer.time_left > 0:
		bottle_sprite.play("default")
		label_sprite.play("default")
	elif !$KinematicBody2D/JumpTimer.time_left > 0:
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
	if body.is_in_group("Player"):
		$KinematicBody2D/ExplodeTimer.start()
		$KinematicBody2D/JumpTimer.stop()
	
	bottle_sprite.play("Explode")
	label_sprite.play("Explode")


func _on_ExplodeTimer_timeout():
	print("CHABOOF")
	var this_explosion = explode_attack.instance()
	this_explosion.global_transform = body.get_global_transform()
	
	get_parent().add_child(this_explosion) 
	
	queue_free()
	shatter()
