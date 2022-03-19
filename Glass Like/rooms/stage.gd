extends Node2D
class_name Stage

export(int) var intensity
onready var enemies = $Enemies
onready var item_spawner = get_node_or_null("ItemSpawner") 

export var shift_speed = 26
var all_enemies_gone_called = false
var can_shift = false

var current_possible_stages

#THIS SHOULD BE IN ITEM
onready var next_stage = load("res://rooms/stages/StageThreeKettles.tscn")
onready var intensity_1_stages = [
	load("res://rooms/stages/StageThreeKettles.tscn")
]

# var current_stages 

# var inenstiy1stages
# var inenstiy2stages
# var inenstiy3stages
# var inenstiy4stages

func ready():
	pass

func _process(delta):
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
		
		
		# THIS SHOULD BE CALLED IN THE ITEM SCENE
#		all_enemies_gone_called = true
#		stage_shift(next_stage)

func stage_shift(selected_stage):
	var this_stage = selected_stage.instance()
	this_stage.global_position.x = get_global_position().x + 1040
	this_stage.global_position.y = get_global_position().y
	get_parent().add_child(this_stage)
	
	can_shift = true
