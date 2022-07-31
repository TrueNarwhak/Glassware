extends RigidBody2D

export var shards = 4
export var spin = 20
export var jump = Vector2(0, -700)
export var x_boost = 250

onready var sprite = $Sprite
onready var anim = $AnimationPlayer


var await_texture 

export(PackedScene) var shard


func _ready():
	
	get_parent().get_node("HerFoyer").bus = "Music"
	
	sprite.texture = await_texture
	anim.play("Decay")
	
	jump.x = [-x_boost, x_boost][randi() % 2]
	apply_central_impulse(jump)

func _process(delta):
	get_parent().get_node("HerFoyer").bus = "Music"

func _on_AnimationPlayer_animation_finished(anim_name):
	# Shard
	for i in shards:
		var this_shard = shard.instance()
		this_shard.position = global_position
		get_tree().get_root().add_child(this_shard)
	
	queue_free()
	
	# Sound
	get_parent().play_break()
