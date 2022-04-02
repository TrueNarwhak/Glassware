extends Area2D

onready var anim = $AnimationPlayer
onready var stage_cast = $StageCast
var sprites = 1

func _ready():
	anim.play("Grow")

func _process(delta):
	yield(anim, "animation_finished")
	anim.play("Idle")
	
	if !stage_cast.is_colliding():
		anim.stop()
		anim.play("Wilt")


func _on_Flower_body_entered(body):
	var this_body = body.get_parent()
	
	if this_body.is_in_group("Enemies"):
		this_body.survive -= 1


func _on_AnimationPlayer_animation_finished(anim_name):	
	if anim_name == "Wilt":
		queue_free()
