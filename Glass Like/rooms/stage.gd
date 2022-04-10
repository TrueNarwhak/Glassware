extends Node2D
class_name Stage

export(int) var intensity
onready var enemies = $Enemies
onready var item_spawner = get_node("ItemSpawner") 

export var shift_speed = 26
var all_enemies_gone_called = false
var can_shift = false

func ready():
	pass

func _process(delta):
#	print(enemies.get_child_count())
#	print(get_nodes_in_group("EnemyProjectile").is_inside_tree())
	
	if enemies.get_child_count() == 0:
		defeated_all()
	
	position.x -= shift_speed
#	position.x = lerp(position.x, -4500*int(all_enemies_gone_called), 0.09)
	
	if !all_enemies_gone_called:
		position.x = clamp(position.x, 0, 1500)
	else:
		position.x = clamp(position.x, -1500, 1500)
	
	if position.x == -1500:
		queue_free()
	if position.x == 0:
		get_node("../Player").set_physics_process(true)

func defeated_all():
	if !all_enemies_gone_called:
		
		if get_node("ItemSpawner"):
			item_spawner.anim.play("ItemSpawn")

func stage_shift(selected_stage):
	var this_stage = selected_stage.instance()
	this_stage.global_position.x = get_global_position().x + 1040
	this_stage.global_position.y = get_global_position().y
	get_parent().add_child(this_stage)
	
	can_shift = true
