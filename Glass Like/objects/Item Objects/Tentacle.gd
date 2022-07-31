extends Position2D

onready var sprite = $Sprite
onready var anim = $AnimationPlayer
onready var slap_sfx = $Slap
onready var uncurl_sfx = $UncurlSound
onready var uncurl_timer = $UncurlTimer
export var pull_force = 400

var chosen_texture
var curl_texture = load("res://images/Attacks/Octopus/CurledTentacle.png")

var curled = false

func _ready():
	anim.play("wiggle")
	
	chosen_texture = sprite.texture

func _process(delta):
	
	if anim.current_animation == "attack":
		anim.playback_speed = 2
	else:
		anim.playback_speed = 1
	
	if curled:
		sprite.texture = curl_texture
	else:
		sprite.texture = chosen_texture

func _on_ActivationBox_body_entered(body):
	var this_body = body.get_parent()
	
	if this_body.is_in_group("Enemies") and !curled:
		anim.play("attack")


func _on_Hitbox_body_entered(body):
	var this_body = body.get_parent()
	
	if this_body.is_in_group("Enemies"):
		
		if !curled:
			# Pull player
			get_parent().get_parent().get_parent().motion = position.direction_to(body.position) * -pull_force
			
			# Break foe
			this_body.survive -= 1
			
			# Play sound
			if !slap_sfx.playing:
				slap_sfx.play()
			
			curled = true
			
			if uncurl_timer.is_stopped():
				uncurl_timer.start()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		anim.play("wiggle")




func _on_UncurlTimer_timeout():
	curled = false
	
	if !get_parent().get_parent().get_parent().jump_death_called:
		uncurl_sfx.play()
