extends Enemy

onready var body = $KinematicBody2D
onready var sprite = $KinematicBody2D/AnimatedSprite
onready var anim_player = $AnimationPlayer
onready var shoot_position = $KinematicBody2D/AnimatedSprite/ShootPosition

export(PackedScene) var coffee_shot

var motion = Vector2(0.0, 1.0)
var can_move = true

export var aim_speed = 0.1
export var speed = 20

var current_speed = speed
# -------------------------------------------------- #

func _ready():
	pass

func _physics_process(delta):
	
	# Face player
	sprite.rotation_degrees = lerp(sprite.rotation_degrees, rad2deg(get_angle_to(player.position)) + 90, aim_speed)
#	sprite.rotation_degrees = rad2deg(get_angle_to(get_node("../Player").position)) + 90
	
	if sprite.rotation_degrees <= 180.0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	# Moving
	current_speed = lerp(current_speed, speed * int(can_move), 0.1)
	position = position.move_toward(player.position, delta * current_speed * int(can_move))

func shoot():
	var this_coffee_shot = coffee_shot.instance()
	
#	this_coffee_shot.position = shoot_position.get_global_position()
	this_coffee_shot.global_transform = shoot_position.get_global_transform()
	this_coffee_shot.motion = player.position - this_coffee_shot.position
	get_parent().add_child(this_coffee_shot)

func _on_ShootTimer_timeout():
	if !can_move:
		anim_player.play("charger")


func _on_ActivationArea_body_entered(body):
	if body.is_in_group("Player"):
		can_move = false
		


func _on_ActivationArea_body_exited(body):
	if body.is_in_group("Player"):
		can_move = true
