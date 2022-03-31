extends Area2D

export var fallspeed = 30
var motion = Vector2.ZERO

onready var pin_cast = $PinCast

func _ready():
	pass

func _process(delta):
	if !pin_cast.is_colliding():
		position.y += fallspeed
	

func _on_Hitbox_body_entered(body):
	var this_body = body.get_parent()
	
	if this_body.is_in_group("Enemies"):
		this_body.survive -= 1
	
	if body.is_in_group("Player"):
			body.shatter()


func _on_PinheadHitbox_area_entered(area):
	if area.is_in_group("SlashAttack"):
		print("A")
		area.get_parent().can_attack_boost = true
