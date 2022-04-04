extends Area2D

export var fallspeed = 30
var motion = Vector2.ZERO
var show_aim = false

onready var pin_cast = $PinCast
onready var line = $Line

onready var player = get_parent().get_node("Player")

func _ready():
	pass

func _process(delta):
	if !pin_cast.is_colliding():
		position.y += fallspeed
	
	line.visible = show_aim
	line.rotation = player.motion.angle()

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


func _on_AimArea_body_entered(body):
	if body.is_in_group("Player"):
		show_aim = true


func _on_AimArea_body_exited(body):
	if body.is_in_group("Player"):
		show_aim = false
