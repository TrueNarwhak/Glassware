extends Area2D

onready var balloon_sprite = $Rubber
onready var string_sprite  = $String
export(PackedScene) var disperse_cloud

onready var balloon_sprite_1 = load("res://images/msc/balloon/Balloon.png")
onready var balloon_sprite_2 = load("res://images/msc/balloon/Balloon1.png")

export var speed = -3
var TARGET_FPS = 60

func _ready():
	randomize()
	balloon_sprite.texture = [balloon_sprite_1, balloon_sprite_2][randi() % 2]

func _process(delta):
	position.y += speed * delta * TARGET_FPS
	
	if position.y < -30:
		queue_free()

func pop():
	var this_disperse = disperse_cloud.instance()
	this_disperse.position   = position
	
	get_parent().add_child(this_disperse)
	
	queue_free()

