extends Node2D
class_name Stage, "res://images/internal/node icons/Plat.png"

const TARGET_FPS = 60

export(int) var intensity
onready var enemies = $Enemies
onready var spawner = $Spawners
#onready var item_spawner = get_node("ItemSpawner") 
onready var player = get_parent().get_node("Player")
onready var camera = get_parent().get_node("LeanCamera")

export var shift_speed = 30
export var zoom_out_on_collect_item = Vector2(1.1, 1.1)
export var zoom_out_speed = 0.4
var all_enemies_gone_called = false
var can_shift = false 
var arrows_before_item = 3

func ready():
	pass

func _process(delta):
	
	# If enemies are all gone
	if enemies.get_child_count() == 0:
		defeated_all()
	
	
	# Constantly shift
	position.x -= (shift_speed + (ItemAndStages.stages_cleared + 1)) * TARGET_FPS * delta
#	position.x = lerp(position.x, -4500*int(all_enemies_gone_called), 0.09)
	
	# Clamp so the stage can actually be effected by shift speed
	if !all_enemies_gone_called:
		position.x = clamp(position.x, 0, 1500)
	else:
		position.x = clamp(position.x, -1500, 1500)
	
	# Destroy old stage when its far enough away
	if position.x == -1500:
		queue_free()
	if position.x == 0:
		get_node("../Player").set_physics_process(true)
	
	# Camera 
	if all_enemies_gone_called:
		camera.zoom = lerp(camera.zoom, zoom_out_on_collect_item, zoom_out_speed)
	
	# Set Item / Stage 
	


func defeated_all():
	
#	if !all_enemies_gone_called:
	
	# Spawning Item / Stage
	if !player.inventory.size() == player.inventory_max: 
		
		
		# Chose between item or arrow aslong as under max items
		if ItemAndStages.stages_cleared % arrows_before_item == 0:
			# Spawning Items
			for item_spawner in spawner.get_children(): # IF IT CATCHES A NULL INSTANCE THAT MEANS THERE ARENT SPAWNERS SET UP IN STAGE
				
				# Spawner
				if item_spawner is Position2D:
					item_spawner.anim.play("ItemSpawn")
					get_parent().get_node("HerFoyer").bus = "MuffledMusic"
				
				# Items 
				if item_spawner.is_in_group("Item") and can_shift:
#					item_spawner.anim.play("Destroy")
					item_spawner.discard()
					get_parent().get_node("HerFoyer").bus = "Music"
			
		else:
			# Spawning Arrow
			if get_node("NextStageArrow") and !get_node("NextStageArrow").spawned:
				get_node("NextStageArrow").anim.play("Spawn")
	
	else:
		if get_node("NextStageArrow") and !get_node("NextStageArrow").spawned:
			get_node("NextStageArrow").anim.play("Spawn")

func stage_shift(selected_stage):
	can_shift = true
	
	var this_stage = selected_stage.instance()
	this_stage.position.x = get_global_position().x + 1040
	this_stage.position.y = get_global_position().y
	get_parent().move_child(this_stage, 1)
	get_parent().add_child(this_stage)

func _exit_tree():
	ItemAndStages.stages_cleared += 1
