extends Area2D

onready var anim = $AnimationPlayer
var spawned = false

func _ready():
	pass

func _process(delta):
#	print(spawned)
	pass

func _on_NextStageArrow_body_entered(body):
	if body.is_in_group("Player"):
		print("collected")
		anim.play("Leave")
		
		# Player Items
		if body.inventory.has("bat"):
			body.current_bat_flap = body.bat_flap
		
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
		anim.play("Idle")
		spawned = true


