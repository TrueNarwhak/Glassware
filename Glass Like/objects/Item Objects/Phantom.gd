extends KinematicBody2D

export var accel_enemy       = 5.0
export var attenuation_enemy = 0.9

export var flicker_speed = 0.4

onready var sprite = $AnimatedSprite
onready var player = get_parent().get_node("Player")

var TARGET_FPS = 60

var motion = Vector2()


enum Moral {
	ATTACK_FOE,
	MORAL_SHIFT
	ATTACK_PLAYER,
}

var state = Moral.ATTACK_FOE

# ------------------------------------------------ #

func _ready():
	randomize()

func _process(delta):
	
	match state:
		Moral.ATTACK_FOE:
#			var toward_target:Vector2 = player.position - position
#
#			motion += accel_enemy * toward_target * delta * TARGET_FPS
#			motion *= attenuation_enemy * delta * TARGET_FPS
#
#			move_and_slide(motion)
#
#			motion.x = clamp(motion.x, 0, 600)
#			motion.y = clamp(motion.x, 0, 600)
#			position.x = clamp(position.x, 0, 960)
#			position.y = clamp(position.y, 0, 540)
			
			position.x = move_toward(position.x, player.position.x, 0.6)
			position.y = move_toward(position.y, player.position.y, 0.6)
