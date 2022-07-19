extends Area2D

onready var anim_player = $AnimationPlayer
onready var sprite = $Sprite

onready var explode_sfx = $Explode

func _ready():
	pass

func _process(delta):
	anim_player.play("Expand")


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()


func _on_ChampaignExplosion_body_entered(body):
	var this_body = body.get_parent()
	
	if body.is_in_group("Player"):
		body.shatter()
	
	if this_body.is_in_group("Enemies"):
		this_body.survive -= 1
