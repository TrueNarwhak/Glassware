extends Area2D

onready var anim = $AnimationPlayer
onready var cause_other_sprout_hitbox = $CauseOtherSpoutHitbox

func _ready():
	anim.play("Grow")

func _process(delta):
	pass


func _on_CauseOtherSpoutHitbox_area_entered(area):
	if area.is_in_group("Flower") and area.can_sprout:
		cause_other_sprout_hitbox.queue_free()
		
		area.make_sprout()
		area.queue_free()


func _on_SproutAttack_body_entered(body):
	var this_body = body.get_parent()
	
	if this_body.is_in_group("Enemies"):
		this_body.survive -= 1
		
	
	if body.is_in_group("EnemyProjectile"):
		queue_free() 

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Grow":
		anim.play("Disappear")
	if anim_name == "Disappear":
		queue_free()



