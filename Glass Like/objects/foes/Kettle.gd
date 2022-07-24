extends Enemy

onready var body = $KinematicBody2D
onready var sprite = $KinematicBody2D/AnimatedSprite
onready var anim_player = $AnimationPlayer
onready var shoot_position = $KinematicBody2D/AnimatedSprite/ShootPosition

onready var charge_sfx = $Charge
onready var shoot_sfx = $Shoot

export(PackedScene) var coffee_shot

var motion = Vector2(0.0, 0.0)
var knock_back_motion = Vector2(0.0, 0.0)
var can_move = true

export var aim_speed = 0.2
export var speed = 20
export var knock_back_force = 179
export var knock_back_drag = 3
export var accel = 0.02

var can_knock_back = false
var current_speed = speed
var current_knock_back_force = knock_back_force

# -------------------------------------------------- #

func _ready():
	pass

func _physics_process(delta):
	# Moving
	if can_knock_back:
		motion = -position.direction_to(player.position) * current_knock_back_force
		current_knock_back_force -= knock_back_drag
		
		current_knock_back_force = clamp(current_knock_back_force, 0, 100000)
		
		if current_knock_back_force == 0:
			can_knock_back = false
		
		sprite.play("Shoot")
	else:
		motion = position.direction_to(player.position) * current_speed
		
		sprite.play("default")
		
	current_speed = lerp(current_speed, speed * int(can_move), accel)
	
	body.move_and_slide(motion, Vector2.ZERO)
	
	# Face player
	sprite.rotation_degrees = lerp(sprite.rotation_degrees, rad2deg(get_angle_to(player.position)) + 90, aim_speed)
#	sprite.rotation_degrees = rad2deg(get_angle_to(get_node("../Player").position)) + 90
	
	if sprite.rotation_degrees <= 180.0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	# Sound 
	if anim_player.current_animation != "charger":
		charge_sfx.stop()
	
	# Clamp
#	body.position.x = clamp(body.position.x, 64, 896)
#	body.position.y = clamp(body.position.y, 40, 600)


func shoot():
	
	# Spawn coffee
	var this_coffee_shot = coffee_shot.instance()
	
	this_coffee_shot.global_transform = shoot_position.get_global_transform()
	this_coffee_shot.motion = player.position - this_coffee_shot.position
	get_parent().add_child(this_coffee_shot)
	
	# Knock back
	can_knock_back = true
	current_knock_back_force = knock_back_force
	
	# Sound
	charge_sfx.stop()
	shoot_sfx.play()


func _on_ShootTimer_timeout():
	if !can_move:
		anim_player.play("charger")


func _on_ActivationArea_body_entered(body):
	if body.is_in_group("Player"):
		can_move = false
 

func _on_ActivationArea_body_exited(body):
	if body.is_in_group("Player"):
#		if body.position.x > 64 and body.position.x < 890 and body.position.y > 40 and body.position.x < 600:
		can_move = true
#	body.position.x = clamp(body.position.x, 64, 896)
#	body.position.y = clamp(body.position.y, 40, 600)

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "charger":
		charge_sfx.play()
	else:
		charge_sfx.stop()
