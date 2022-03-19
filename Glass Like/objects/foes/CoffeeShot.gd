extends KinematicBody2D

export var speed = 1600

onready var player = get_parent().get_parent().get_node("../Player")

var motion = Vector2(0.0, 1.0)

func _ready():
	look_at(player.position)

func _physics_process(delta):
	var collision_info = move_and_collide(motion.normalized() * delta * speed)


func _on_Hitbox_body_entered(body):
	if body.is_in_group("Player"):
		body.shatter()
