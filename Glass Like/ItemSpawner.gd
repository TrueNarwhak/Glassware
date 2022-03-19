extends Position2D

export(PackedScene) var item

onready var anim = $AnimationPlayer

func _ready():
	pass

func _process(delta):
	pass

func spawn_item():
	var this_item = item.instance()
	this_item.global_position = get_global_position()
	get_parent().add_child(this_item)


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
