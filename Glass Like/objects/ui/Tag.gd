extends Node2D

export(String) var room_path

export var mouseover_destination = -10.0
export var rotate_speed = 0.2
var rotate_destination = 0


func _ready():
	pass

func _process(delta):
	rotation_degrees = lerp(rotation_degrees, rotate_destination, rotate_speed)


func _on_TextureButton_button_down():
	get_tree().change_scene(room_path)

func _on_TextureButton_mouse_entered():
	rotate_destination = mouseover_destination


func _on_TextureButton_mouse_exited():
	rotate_destination = 0.0
