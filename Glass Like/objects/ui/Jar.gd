extends Control
class_name Jar

onready var area = $Area2D
onready var anim = $AnimationPlayer
onready var sprite = $Sprite

export var inflate_value = 1.1


export(String) var jar_function 
var mouse_in = false

# --------------------------------------- #

func _ready():
	area.connect("mouse_entered", self, "_on_Area2D_mouse_entered")
	area.connect("mouse_exited", self, "_on_Area2D_mouse_exited")
	anim.play("Idle")

func _process(delta):
	
	# Animation
	sprite.scale.x = lerp(sprite.scale.x, inflate_value*int(mouse_in), 0.1)
	sprite.scale.x = clamp(sprite.scale.x, 1, 2)
	
	sprite.scale.y = lerp(sprite.scale.y, inflate_value*int(mouse_in), 0.1)
	sprite.scale.y = clamp(sprite.scale.y, 1, 2)
	
	# Click
	if mouse_in and Input.is_action_just_pressed("ui_accept"):
		call(jar_function)

func play():
	print("play")

func more_ways():
	pass

func options():
	pass

func quit_game():
	pass


func _on_Area2D_mouse_entered():
	mouse_in = true


func _on_Area2D_mouse_exited():
	mouse_in = false
