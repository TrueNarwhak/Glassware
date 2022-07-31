extends Area2D

onready var anim = $AnimationPlayer
var spawned = false

onready var player = get_parent().get_parent().get_node("Player")

func _ready():
	$CollisionShape2D.disabled = true

func _process(delta):
#	print(spawned)
	pass
	
	# Player Items
#	if spawned and player.inventory.has("bat"):
#		player.current_bat_flap = player.bat_flap

func _on_NextStageArrow_body_entered(body):
	if body.is_in_group("Player"):
		print("collected")
		anim.play("Leave")
		
		# Player Items
		if body.inventory.has("bat"):
			body.current_bat_flap = body.bat_flap
		
		# Player invincibility
		body.invincible = true
		body.invincibility_timer.start()
		
		# Attacks
		body.can_attack_boost = true
		body.set_physics_process(false)
	
		# Stage
		ItemAndStages.next_stage = ItemAndStages.intensity_1_stages[randi() % ItemAndStages.intensity_1_stages.size()]
		
		get_parent().all_enemies_gone_called = true
		get_parent().stage_shift(ItemAndStages.next_stage)
		queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Spawn":
		anim.play("Idle2")
		spawned = true


