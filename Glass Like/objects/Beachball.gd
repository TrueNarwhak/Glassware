extends RigidBody2D

export var ball_force = 750
export var player_force = 750

onready var hitbox = $Area2D
onready var bounce_sfx = $BounceSFX

var motion = Vector2(0.0, 0.0)
var active = false

var bounce_sounds = [
	load("res://sound/sfx/impact soft heavy/impactSoft_heavy_000.ogg"), 
	load("res://sound/sfx/impact soft heavy/impactSoft_heavy_001.ogg"), 
	load("res://sound/sfx/impact soft heavy/impactSoft_heavy_002.ogg"), 
	load("res://sound/sfx/impact soft heavy/impactSoft_heavy_003.ogg"), 
	load("res://sound/sfx/impact soft heavy/impactSoft_heavy_004.ogg")
]

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
	
	# Sound
	if active:
		if body is StaticBody2D or body.is_in_group("Player") or body.is_in_group("Beachball") or body.is_in_group("Enemies"):
			bounce_sfx.stream = bounce_sounds[randi() % bounce_sounds.size()]
			bounce_sfx.play()

func _on_Timer_timeout():
	active = true
	
	set_collision_layer(1)
	set_collision_mask(1)
	
	hitbox.set_collision_layer(1)
	hitbox.set_collision_mask(1)

