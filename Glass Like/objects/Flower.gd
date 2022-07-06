extends Area2D

onready var anim = $AnimationPlayer
onready var stage_cast = $StageCast
var sprites = 1

export(PackedScene) var sprout
export var slowed_speed = 100

var can_sprout = false

# ----------------------------------------------- #

func _ready():
	anim.play("Grow")

func _process(delta):
	yield(anim, "animation_finished")
	anim.play("Idle")
	
	if !stage_cast.is_colliding():
		anim.stop()
		anim.play("Wilt")

func make_sprout():
	var this_sprout = sprout.instance()
	
	this_sprout.position.x = get_global_position().x
	this_sprout.position.y = get_global_position().y -85
	get_parent().add_child(this_sprout)

func _on_Flower_body_entered(body):
#	var this_body = body.get_parent()
#
#	if this_body.is_in_group("Enemies"):
#		this_body.survive -= 1
	
	if body.is_in_group("Player") and body.is_on_floor():
		body.MAX_SPEED = slowed_speed


func _on_Flower_body_exited(body):
	if body.is_in_group("Player"):
		body.MAX_SPEED = body.default_max_speed


func _on_CanSproutTimer_timeout():
	can_sprout = true


func _on_AnimationPlayer_animation_finished(anim_name):	
	if anim_name == "Wilt":
		queue_free()


