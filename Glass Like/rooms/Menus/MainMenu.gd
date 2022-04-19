extends Node2D

var loaded_seed

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


func _on_Play_pressed():
	get_tree().change_scene("res://rooms/Controller.tscn")


func _on_OpenSeed_pressed():
	OS.shell_open("C:/Users/name/Downloads")
