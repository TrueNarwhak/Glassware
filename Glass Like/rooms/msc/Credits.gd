extends Node2D

export(PackedScene) var balloon

func _ready():
	# OPTIONS INIT
	# todo - options global
	if !OS.has_feature("HTML"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	
	OS.window_fullscreen = Options.fullscreen
	
	randomize()

func _process(delta):
	
	if Input.is_action_just_pressed("pause"):
		get_tree().reload_current_scene()
	
	# Full Screen
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
		Options.fullscreen = OS.window_fullscreen
	
	if OS.window_fullscreen or OS.has_feature("HTML"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)



func _on_NextStageArrow_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().change_scene("res://rooms/Controller.tscn")


func _on_BalloonTimer_timeout():
	var this_balloon = balloon.instance()
	this_balloon.position.x = (randi()%881) - 78
	this_balloon.position.y = 595
	add_child(this_balloon)
