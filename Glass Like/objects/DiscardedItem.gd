extends RigidBody2D

export var shards = 4
export var spin = 20
export var jump = Vector2(0, -700)

onready var sprite = $Sprite
onready var anim = $AnimationPlayer

export(PackedScene) var shard

func _ready():
	anim.play("Decay")
	apply_central_impulse(jump)

func _process(delta):
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	# Shard
	for i in shards:
		var this_shard = shard.instance()
		this_shard.position = global_position
		get_tree().get_root().add_child(this_shard)
	
	queue_free()
