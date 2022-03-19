extends Area2D

onready var anim = $AnimationPlayer
var sprites = 1

func _ready():
	anim.play("Grow")

func _process(delta):
	yield(anim, "animation_finished")
	anim.play("Idle")


func _on_Flower_body_entered(body):
	var this_body = body.get_parent()
	
	if this_body.is_in_group("Enemies"):
		this_body.survive -= 1

	
