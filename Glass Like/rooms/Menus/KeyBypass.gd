extends Node2D

onready var shard = preload("res://objects/shards/EnemyShards.tscn")

onready var key_parent = $Keys
onready var up = $Keys/Up
onready var down = $Keys/Down
onready var left = $Keys/Left
onready var right = $Keys/Right
onready var mouse = $Keys/Mouse
onready var break_sfx = $Break

onready var goto_timer = $GotoTimer

onready var camera = get_node("LeanCamera")

export(int) var shards = 10

var keys_left = 5

var break_sounds = [
	load("res://sound/sfx/GlassBreak/BTD glass break 1.ogg"), 
	load("res://sound/sfx/GlassBreak/BTD glass break 2.ogg"), 
	load("res://sound/sfx/GlassBreak/BTD glass break 3.ogg"), 
	load("res://sound/sfx/GlassBreak/BTD glass break 4.ogg")
]

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	randomize()
	

func _process(delta):
	
	# Keys
	if Input.is_action_just_pressed("jump") and key_parent.get_node("Up"):
		remove_key(up)
	if Input.is_action_just_pressed("move_down") and key_parent.get_node("Down"):
		remove_key(down)
	if Input.is_action_just_pressed("move_left") and key_parent.get_node("Left"):
		remove_key(left)
	if Input.is_action_just_pressed("move_right") and key_parent.get_node("Right"):
		remove_key(right)
	if Input.is_action_just_pressed("attack") and key_parent.get_node("Mouse"):
		remove_key(mouse)
	
	# Full Screen
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
		Options.fullscreen = OS.window_fullscreen
	
	# Start Key Timer
	if key_parent.get_child_count() == 0:
		if goto_timer.is_stopped():
			goto_timer.start()

func remove_key(key):

	# Break
	for i in shards:
		var this_shard = shard.instance()
		this_shard.position = key.global_position
		get_tree().get_root().add_child(this_shard)
		
	
	# Start Key Timer
#	if key_parent.get_child_count() == 1:
#		if goto_timer.is_stopped():
#			goto_timer.start()
	
	# Camera
	camera.rotation_degrees = [camera.rotate_shake*2, -camera.rotate_shake*2][randi() % 2]
	camera.zoom = Vector2(camera.zoom_pop, camera.zoom_pop)
	
	# Free Key
	key.queue_free()
	
	break_sfx.stream = break_sounds[randi() % break_sounds.size()]
	break_sfx.play()


func _on_GotoTimer_timeout():
	get_tree().change_scene_to(load("res://rooms/Controller.tscn"))
	print("a")
