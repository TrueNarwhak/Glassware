extends Area2D

onready var anim = $AnimationPlayer

func _ready():
	anim.play("Grow")


# KEEEEEEEEEEEEEEEEEEEP NOTE OF REACTION TO EXPLOSION LIKE READING AND SPEED AND MOUDLATE.A

func _on_Star_body_entered(body):
	var this_body = body.get_parent()
	
	if this_body.is_in_group("Enemies"):
		this_body.survive -= 1


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
