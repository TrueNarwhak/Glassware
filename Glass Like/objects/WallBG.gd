extends Node2D

onready var sprite = $AnimatedSprite

func _ready():
	pass

func _process(delta):
	sprite.speed_scale = 1 + (ItemAndStages.stages_cleared / 2)
	sprite.speed_scale = clamp(sprite.speed_scale, 0, 20)
