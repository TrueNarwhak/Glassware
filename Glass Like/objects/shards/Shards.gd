extends RigidBody2D
class_name Shards, "res://images/internal/node icons/Shard.png"

var health = 420
var fade_point = 100

onready var fall_click_sfx = $FallClick
var fall_click_sounds = [
	load("res://sound/sfx/Fall Clicks/glass fall click1.ogg"), 
	load("res://sound/sfx/Fall Clicks/glass fall click2.ogg"), 
	load("res://sound/sfx/Fall Clicks/Glass fall clicks3.ogg")
]


func _ready():
	randomize()
	var rand_x = rand_range(-800, 800)
	var rand_y = rand_range(-800, 800)

	apply_central_impulse(Vector2(rand_x, rand_y))

	# THE ISSUE HERE IS THE SHARDS COLLIDE WITH THEMSEVLES AND FALL
	# SET PHYSICS LAYER TO NOT COLLIDE WITH ITSELF
#	var rand_offset_x = rand_range(-100, 100)
#	var rand_offset_y = rand_range(-100, 100)
#
#	apply_central_impulse(get_global_mouse_position() - Vector2(rand_offset_x, rand_offset_y))
	$Sprite.frame = randi() % 6
	
	connect("body_entered", self, "_on_Shard_body_entered")
	

func _process(delta):
	health -= 1
	
	if health <= 0:
		queue_free()
	
	modulate.a = lerp(modulate.a, 1 * int(health >= fade_point), 0.2)
	

func _physics_process(delta):
	pass

func _on_Shard_body_entered(body):
	
	if !fall_click_sfx.playing and health >= fade_point:
		fall_click_sfx.stream = fall_click_sounds[randi() % fall_click_sounds.size()]
		fall_click_sfx.play()
