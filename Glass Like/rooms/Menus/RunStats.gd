extends Node2D

onready var anim = $Control/AnimationPlayer

var can_respawn = false

func _ready():
	anim.play("ComeIn")

func _process(delta):
	if Input.is_action_just_pressed("restart") and can_respawn:
		get_tree().reload_current_scene()


func _on_AnimationPlayer_animation_finished(anim_name):
	can_respawn = true
