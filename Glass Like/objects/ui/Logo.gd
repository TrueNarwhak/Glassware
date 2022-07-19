extends Node2D

export(String) var link

onready var anim = $AnimationPlayer

func _ready():
	pass


func _on_TextureRect_pressed():
	OS.shell_open(link)


func _on_TextureRect_mouse_entered():
	anim.play("Grow")
	get_parent().get_parent().is_over_ui = true


func _on_TextureRect_mouse_exited():
	anim.play("Shrink")
	get_parent().get_parent().is_over_ui = false
