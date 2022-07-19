extends Node2D

export var speed = 6
export var modulation_speed = 0.1

var min_catalouge = 486.0
var max_catalouge = 2877.0

var sidebar_1_inside = false
var sidebar_2_inside = false

var TARGET_FPS = 60
export var base_modulate = 0.84

var target_modulation_r = 0.0
var target_modulation_l = 0.0

onready var catalouge = $Catalouge
onready var camera = $Camera2D

onready var sidebar_l = $Camera2D/Sidebar
onready var sidebar_r = $Camera2D/Sidebar2

func _ready():
	pass

func _process(delta):
	
	sidebar_r.modulate.a = lerp(sidebar_r.modulate.a, target_modulation_r, modulation_speed)
	sidebar_l.modulate.a = lerp(sidebar_l.modulate.a, target_modulation_l, modulation_speed)
	
	camera.global_position.x = clamp(camera.global_position.x, min_catalouge, max_catalouge)
	
	if sidebar_1_inside:
		camera.position.x -= speed * delta * TARGET_FPS
		
	
	if sidebar_2_inside:
		camera.position.x += speed * delta * TARGET_FPS


func _on_Sidebar_mouse_entered():
	sidebar_1_inside = true
	target_modulation_l = base_modulate
	$Slide1.play()


func _on_Sidebar_mouse_exited():
	sidebar_1_inside = false
	target_modulation_l = 0.0


func _on_Sidebar2_mouse_entered():
	sidebar_2_inside = true
	target_modulation_r = base_modulate
	$Slide2.play()


func _on_Sidebar2_mouse_exited():
	sidebar_2_inside = false
	target_modulation_r = 0.0


func _on_TextureButton_pressed():
	get_tree().change_scene("res://rooms/Controller.tscn")
