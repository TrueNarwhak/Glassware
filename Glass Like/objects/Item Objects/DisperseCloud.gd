extends Node2D

onready var anim = $AnimationPlayer

func _ready():
	anim.play("Disperse")


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
