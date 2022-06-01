extends Node2D

func _ready():
	# OPTIONS INIT
	# todo - options global
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	
	OS.window_fullscreen = Options.fullscreen

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().reload_current_scene()
	
	# Full Screen
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
		Options.fullscreen = OS.window_fullscreen
	
	if OS.window_fullscreen:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
