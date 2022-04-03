extends Node2D

func _ready():
	# OPTIONS INIT
	# todo - options global
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().reload_current_scene()
