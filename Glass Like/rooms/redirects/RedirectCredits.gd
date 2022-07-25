extends Node2D

onready var path = preload("res://rooms/msc/Credits.tscn") 

func _ready():
	get_tree().change_scene(path)
