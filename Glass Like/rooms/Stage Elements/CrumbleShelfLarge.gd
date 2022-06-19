extends StaticBody2D
class_name CrumbleShelf

onready var anim = $AnimationPlayer
export var crumble_speed = 1.0

func _ready():
	anim.playback_speed = crumble_speed
	
	anim.play("Crumble")
	anim.stop()

func _process(delta):
	pass

func _on_ActivationArea_body_entered(body):
	var this_body = body.get_parent()
	
	if this_body.is_in_group("Enemies") or body.is_in_group("Player"):
		anim.play("Crumble")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Crumble":
		queue_free()
