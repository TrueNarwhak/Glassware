extends Node2D
class_name Enemy, "res://images/internal/node icons/Cup2.png"

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
		get_parent().get_parent().get_parent().add_child(this_shard)
	
	# Shake
	if camera:
		#camera.shake()
		camera.rotation_degrees = [camera.rotate_shake, -camera.rotate_shake][randi() % 2]
		camera.zoom = Vector2(camera.zoom_pop, camera.zoom_pop)
	
	# Sound
	get_parent().get_parent().get_parent().play_break()
	
	print("death of enemy")
	queue_free()
