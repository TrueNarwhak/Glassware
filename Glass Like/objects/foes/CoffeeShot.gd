extends KinematicBody2D

export var speed = 690
export var speed_increase = 60

var TARGET_FPS = 60
var is_reflected = false

onready var player = get_parent().get_parent().get_node("../Player")
onready var sprite = $Sprite

var motion = Vector2(0.0, 1.0)

func _ready():
	look_at(player.position)

func _physics_process(delta):
	var collision_info = move_and_collide(motion.normalized() * delta * speed)
	speed += speed_increase * delta * TARGET_FPS

func _on_Hitbox_body_entered(body):
	var this_body = body.get_parent()
	
	if body.is_in_group("Player") and !is_reflected:
		body.shatter()
	
	if this_body.is_in_group("Enemies") and is_reflected:
		this_body.survive -= 1
