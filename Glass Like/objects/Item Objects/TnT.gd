extends RigidBody2D

export(PackedScene) var explosion
export var bump_boost = Vector2(0, -500)
export var spin_speed = 400

onready var blow_timer = $BlowTimer
onready var camera = get_parent().get_node("LeanCamera")

func _ready():
	blow_timer.start()
	apply_central_impulse(bump_boost)

func _process(delta):
	$Sprite.rotation_degrees += spin_speed * delta

func _on_Timer_timeout():
	queue_free()
	
	# Camera 
	if camera:
		#camera.shake()
		camera.rotation_degrees = [camera.rotate_shake, -camera.rotate_shake][randi() % 2]
		camera.zoom = Vector2(camera.zoom_pop, camera.zoom_pop)
	
	# Explode
	var this_explosion = explosion.instance()
	this_explosion.scale /= 3
	this_explosion.global_position = global_position
	get_parent().add_child(this_explosion)
