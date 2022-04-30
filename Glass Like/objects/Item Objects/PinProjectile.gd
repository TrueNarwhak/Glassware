extends Area2D

export var fallspeed = 2500
export var head_lerp_speed = 0.2
export var head_pop = 1.4
var motion = Vector2.ZERO
var show_aim = false

onready var pin_cast = $PinCast
onready var line = $Line
onready var hitbox_shape = $Hitbox/CollisionShape2D
onready var head_sprite = $Head
onready var needle_sprite = $Needle

onready var player = get_parent().get_node("Player")

func _ready():
	pass

func _process(delta):
	
	# Pin
	if !pin_cast.is_colliding():
		position.y += fallspeed * delta
	
	# Line
	line.visible = show_aim
	line.rotation = player.motion.angle()
	
	# Head
	head_sprite.scale = lerp(head_sprite.scale, Vector2(1,1), head_lerp_speed)

func _on_Hitbox_body_entered(body):
	var this_body = body.get_parent()
	
	if this_body.is_in_group("Enemies"):
		this_body.survive -= 1
	
	if body.is_in_group("Player") and !pin_cast.is_colliding():
			body.shatter()


func _on_PinheadHitbox_area_entered(area):
	if area.is_in_group("SlashAttack"):
		print("A")
		var player = area.get_parent()
		
		# Boost
#		player.can_attack_boost = true
		
		if !player.is_on_floor():
			player.motion = (player.attack_force * 1.35) * get_local_mouse_position().normalized()
			player.can_attack_boost = false
		
		# Anim
		head_sprite.scale = Vector2(head_pop,head_pop)


func _on_AimArea_body_entered(body):
	if body.is_in_group("Player"):
		show_aim = true


func _on_AimArea_body_exited(body):
	if body.is_in_group("Player"):
		show_aim = false

