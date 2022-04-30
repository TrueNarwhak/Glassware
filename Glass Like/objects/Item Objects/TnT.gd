extends RigidBody2D

export(PackedScene) var explosion
export var bump_boost = Vector2(0.0, -400.0)
export var spin_speed = 400

func _ready():
	$Timer.start()
	apply_impulse(position, bump_boost)

func _process(delta):
	$Sprite.rotation_degrees += spin_speed * delta

func _on_Timer_timeout():
	queue_free()
	var this_explosion = explosion.instance()
	this_explosion.scale /= 3
	this_explosion.global_position = global_position
	get_parent().add_child(this_explosion)
