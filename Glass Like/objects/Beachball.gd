extends RigidBody2D

export var ball_force = 750
export var player_force = 750

onready var hitbox = $Area2D

var motion = Vector2(0.0, 0.0)

func _ready():
	apply_central_impulse(position.direction_to( get_viewport().get_mouse_position()) * ball_force)
	randomize()

func _process(delta):
	pass

func _physics_process(delta):
	pass

func _on_Area2D_body_entered(body):
	var this_body = body.get_parent()
	
	if body.is_in_group("Player"):
		body.motion = position.direction_to( -get_viewport().get_mouse_position()) * player_force
		body.can_attack_boost = true
	
	if this_body.is_in_group("Enemies"):
		this_body.survive -= 1

func _on_Timer_timeout():
	set_collision_layer(1)
	set_collision_mask(1)
	
	hitbox.set_collision_layer(1)
	hitbox.set_collision_mask(1)

