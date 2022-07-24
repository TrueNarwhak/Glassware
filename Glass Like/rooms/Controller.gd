extends Node2D

onready var music = $HerFoyer
onready var break_sfx = $Break

var break_sounds = [
	load("res://sound/sfx/GlassBreak/BTD glass break 1.ogg"), 
	load("res://sound/sfx/GlassBreak/BTD glass break 2.ogg"), 
	load("res://sound/sfx/GlassBreak/BTD glass break 3.ogg"), 
	load("res://sound/sfx/GlassBreak/BTD glass break 4.ogg")
]

func _ready():
	randomize()
	
	# OPTIONS INIT
	# todo - options global     <--------- lol i did not do this
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

func play_break():
	break_sfx.stream = break_sounds[randi() % break_sounds.size()]
	break_sfx.play()
