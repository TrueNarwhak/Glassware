extends Area2D

var mouse_inside : bool

onready var player = get_parent().get_node("Player")
onready var format_timer = $FormatTimer
onready var sprite = $AnimatedSprite

func _ready():
	pass

func _process(delta):
	print(mouse_inside)
	if Input.is_action_just_pressed("ui_accept"):
		print("LOADED")
		
		player.global_position = get_global_position()
		player.set_physics_process(false)
		player.set_process(false)
		
		sprite.hide()
		format_timer.start()

func _on_Floppydisk_mouse_entered():
	mouse_inside = true
	print("erm")

func _on_Floppydisk_mouse_exited():
	mouse_inside = false


func _on_FormatTimer_timeout():
	player.set_physics_process(false)
	player.set_process(false)
