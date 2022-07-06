extends Area2D

export var extra_boost_force = 200
export(PackedScene) var tnt 
export(PackedScene) var pin
export(PackedScene) var ghost

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
				
				# Item
				tnt_item_attack(this_body)
				pin_item_attack(this_body)
				ghost_item_attack(this_body)
				
				# Kill
				this_body.survive -= 1
				
				get_parent().can_attack_boost = true
	#			get_parent().motion = extra_boost_force * get_local_mouse_position().normalized()
			
			if body.is_in_group("EnemyProjectile") and get_parent().inventory.has("baseball"):
				print("reflect!")
				
				body.motion = -body.motion*2
				body.is_reflected = true
				body.sprite.flip_h = true
			
			if body.is_in_group("Ghost"):
				if body.state == 3:
					body.disperse()

func _on_SlashAttack_area_entered(area):
	if area.is_in_group("SproutActivationArea") and area.get_parent().can_sprout:
		area.get_parent().make_sprout()
		area.get_parent().queue_free()


# ------------------------------------------------------ #


func tnt_item_attack(this_body):
	if get_parent().inventory.has("tnt"):
		var this_tnt = tnt.instance()
		this_tnt.global_position = this_body.body.get_global_position()
		get_parent().get_parent().add_child(this_tnt)



func pin_item_attack(this_body):
	if get_parent().inventory.has("pin"):
		var this_pin = pin.instance()
		
#					this_pin.position.y = -100
		this_pin.position.x = randi() % 960 + 100
		get_parent().get_parent().add_child(this_pin)



func ghost_item_attack(this_body):
	if get_parent().inventory.has("ghost"):
		var this_ghost = ghost.instance()
		
		this_ghost.global_position = this_body.body.get_global_position()
		get_parent().get_parent().add_child(this_ghost)

# ------------------------------------------------------ #
