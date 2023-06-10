extends "res://objects/NextStageArrow.gd"

func _on_NextStagePortal_body_entered(body):
	.swap_stage(body)

func _on_AnimationPlayer_animation_finished(animation):
	if animation == "Spawn":
		anim.play("Idle")
