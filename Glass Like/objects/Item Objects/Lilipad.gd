extends KinematicBody2D

export var offset = -148
export var throw_boost = 100
export var gravity = 21
export var player_fall_throw = 21

onready var player = get_parent().get_node("Player")
onready var sprite = $AnimatedSprite

enum {
	GOING_UP,
	THROWN,
	FALLING
}

var state = GOING_UP
var motion = Vector2.ZERO
var TARGET_FPS = 60

# --------------------------------------- #

func _ready():
	pass

func _physics_process(delta):
	match state:
		GOING_UP:
			position.x = player.position.x
			position.y = player.position.y + offset
			
			if player.motion.y > -player_fall_throw:
				state = THROWN
		
		THROWN:
			motion.y = -throw_boost
			sprite.frame = 0
			
			motion = move_and_slide(motion)
			
			state = FALLING
		
		FALLING:
			motion.y += gravity * delta * TARGET_FPS
			
			if motion.y > 500: 
				sprite.frame = 1 
			else:
				sprite.frame = 2
			
			motion = move_and_slide(motion)
	
	# Cleanest code in the west B)
	#                           |


func _on_Hitbox_body_entered(body):
	var this_body = body.get_parent()
	
	if this_body.is_in_group("Enemies"):
		this_body.survive -= 1


func _on_GoingupHitbox_body_entered(body):
	var this_body = body.get_parent()
	
	if state == GOING_UP:
		if this_body.is_in_group("Enemies"):
			this_body.survive -= 1
