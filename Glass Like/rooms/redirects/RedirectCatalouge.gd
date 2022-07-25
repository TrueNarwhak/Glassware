extends Node2D

onready var path = preload("res://objects/ui/Catalouge.tscn") 

func _ready():
	get_tree().change_scene(path)
