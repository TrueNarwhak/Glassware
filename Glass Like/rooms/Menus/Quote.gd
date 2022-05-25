extends Node2D

onready var anim = $AnimationPlayer
var quotes = [
	"Come Again Soon!",
	"Want a lolipop?",
	"Don't check the crack in the walls..."
]

func _ready():
	anim.play("QuoteZoom")


func switch_scene():
	get_tree().change_scene("res://rooms/Controller.tscn")

func _on_AnimationPlayer_animation_finished(anim_name):
	pass
