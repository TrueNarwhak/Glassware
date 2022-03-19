extends Area2D


func _ready():
	$AnimationPlayer.play("Expand")

func _process(delta):
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()


func _on_AnvilStomp_body_entered(body):
	var this_body = body.get_parent()
	
	if this_body.is_in_group("Enemies"):
		this_body.survive -= 1
