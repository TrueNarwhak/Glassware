extends Area2D

onready var anim = $AnimationPlayer

func _ready():
	anim.play("Spawn")

func _process(delta):
	pass

func _on_NextStageArrow_area_entered(area):
	print("aaahah its inside-a me!")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Spawn":
		anim.play("Idle")
