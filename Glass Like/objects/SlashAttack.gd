extends Area2D

export var extra_boost_force = 200

func _ready():
	$AnimationPlayer.play("Attacking")
	look_at(get_global_mouse_position())
	
	if rotation_degrees < -90:
		$Sprite.flip_v = true

func _process(delta):
	pass

func end():
	get_parent().is_attacking = false
	queue_free()


func _on_SlashAttack_body_entered(body):
		var this_body = body.get_parent()
		
		if is_processing():
			if this_body.is_in_group("Enemies"):
				this_body.survive -= 1
				
				get_parent().can_attack_boost = true
	#			get_parent().motion = extra_boost_force * get_local_mouse_position().normalized()
			
			if body.is_in_group("EnemyProjectile") and get_parent().inventory.has("baseball"):
				print("reflect!")
				body.motion = -body.motion
