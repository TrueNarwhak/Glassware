extends Position2D

onready var anim = $AnimationPlayer
onready var slap_sfx = $Slap
export var pull_force = 400


func _ready():
	anim.play("wiggle")

func _process(delta):
	if anim.current_animation == "attack":
		anim.playback_speed = 2
	else:
		anim.playback_speed = 1


func _on_ActivationBox_body_entered(body):
	var this_body = body.get_parent()
	
	if this_body.is_in_group("Enemies"):
		anim.play("attack")


func _on_Hitbox_body_entered(body):
	var this_body = body.get_parent()
	
	if this_body.is_in_group("Enemies"):
		
		# Pull player
		get_parent().get_parent().get_parent().motion = position.direction_to(body.position) * -pull_force
		
		# Break foe
		this_body.survive -= 1
		
		# Play sound
		if !slap_sfx.playing:
			slap_sfx.play()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		anim.play("wiggle")


