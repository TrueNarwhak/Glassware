extends Node2D
class_name Enemy

export var survive = 1
export var shards = 6

onready var shard = preload("res://objects/shards/EnemyShards.tscn")

onready var player = get_parent().get_parent().get_node("../Player")
onready var camera = get_parent().get_parent().get_node("../LeanCamera")

func _ready():
	pass

func _process(delta):
	
	# Death
	if survive <= 0:
		shatter()
	
	# Activation
#	if get_parent().get_global_position().x == 0:
#		set_process(true)
#		set_physics_process(true)
#	else:
#		set_process(false)
#		set_physics_process(false)

func uhhhhh():
	print("aaaa")

func shatter():
	# Spew shards
	for i in shards:
		var this_shard = shard.instance()
		this_shard.position = $KinematicBody2D.get_global_position()
		get_tree().get_root().add_child(this_shard)
	
	# Shake
	if camera:
		camera.shake()
	
	print("death of enemy")
	queue_free()
