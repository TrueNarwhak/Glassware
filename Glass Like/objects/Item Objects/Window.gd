extends Area2D

onready var window_sprite = $Sprites/WindowSprite
onready var x_sprite      = $Sprites/XSprite
onready var anim          = $AnimationPlayer

func _ready():
	anim.play("Appear")

func _process(delta):
	pass


func _on_Window_body_entered(body):
	if body.is_in_group("Enemies") or body.is_in_group("EnemyProjectile"):
		body.set_process(false)
		body.set_physics_process(false)
