extends Node2D

onready var anim = $AnimationPlayer
onready var ghost_poof_sfx = $GhostPoof
onready var balloon_pop_sfx = $BalloonPop
var is_ghost = true


func _ready():
	anim.play("Disperse")
	
	if is_ghost:
		ghost_poof_sfx.play()
	else:
		balloon_pop_sfx.play()


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
