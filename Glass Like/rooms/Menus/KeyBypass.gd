extends Node2D

onready var shard = preload("res://objects/shards/EnemyShards.tscn")

onready var key_parent = $Keys
onready var up = $Keys/Up
onready var down = $Keys/Down
onready var left = $Keys/Left
onready var right = $Keys/Right
onready var mouse = $Keys/Mouse

onready var goto_timer = $GotoTimer

onready var camera = get_node("LeanCamera")

export(int) var shards = 10

var keys_left = 5

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _process(delta):
	
	if Input.is_action_just_pressed("jump"):
		remove_key(up)
	if Input.is_action_just_pressed("move_down"):
		remove_key(down)
	if Input.is_action_just_pressed("move_left"):
		remove_key(left)
	if Input.is_action_just_pressed("move_right"):
		remove_key(right)
	if Input.is_action_just_pressed("attack"):
		remove_key(mouse)


func remove_key(key):

	# Break
	for i in shards:
		var this_shard = shard.instance()
		this_shard.position = key.get_global_position()
		get_tree().get_root().add_child(this_shard)
		
	
	# Start Key Timer
	if key_parent.get_child_count() == 1:
		goto_timer.start()
	
	# Camera
	camera.rotation_degrees = [camera.rotate_shake*2, -camera.rotate_shake*2][randi() % 2]
	camera.zoom = Vector2(camera.zoom_pop, camera.zoom_pop)
	
	# Free Key
	key.queue_free()


func _on_GotoTimer_timeout():
	get_tree().change_scene("res://rooms/Controller.tscn")
	print("a")
