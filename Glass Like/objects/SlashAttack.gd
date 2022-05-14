extends Area2D

export var extra_boost_force = 200
export(PackedScene) var tnt 
export(PackedScene) var pin

# ----------------------------------------------- #

func _ready():
	randomize()
	
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
				
				# TNT
				if get_parent().inventory.has("tnt"):
					var this_tnt = tnt.instance()
					this_tnt.global_position = this_body.body.get_global_position()
					get_parent().get_parent().add_child(this_tnt)
				
				# Pin
				if get_parent().inventory.has("pin"):
					var this_pin = pin.instance()
					
#					this_pin.position.y = -100
					this_pin.position.x = randi() % 960 + 100
					get_parent().get_parent().add_child(this_pin)
				
				# Kill
				this_body.survive -= 1
				
				get_parent().can_attack_boost = true
	#			get_parent().motion = extra_boost_force * get_local_mouse_position().normalized()
			
			if body.is_in_group("EnemyProjectile") and get_parent().inventory.has("baseball"):
				print("reflect!")
				
				body.motion = -body.motion*2
				body.is_reflected = true
				body.sprite.flip_h = true


func _on_SlashAttack_area_entered(area):
	if area.is_in_group("Flower") and area.can_sprout:
		area.make_sprout()
		area.queue_free()
