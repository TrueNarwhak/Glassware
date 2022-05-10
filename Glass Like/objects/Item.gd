extends Area2D

onready var sprite = $Visual/Item
onready var anim = $AnimationPlayer
onready var collision_shape = $CollisionShape2D

onready var itemhud = get_parent().get_parent().get_parent().get_node("ItemHud")
export(PackedScene) var discarded_item

var item_index
var item_selected

signal collected

# -------------------------------------------------------------------- #

func _ready():
	randomize()
	connect("collected", self, "_on_Item_collected")
	
	# Pick and remove items
	item_index = randi() % ItemAndStages.items_current.size()

	sprite.texture = ItemAndStages.item_sprites[item_index]
	item_selected = ItemAndStages.items_current[item_index]
	
	# Start anim
	anim.play("Idle") 
	
#	print(items_current)
#	print(item_index)
#	print(item_selected)

func _process(delta):
#	print(ItemAndStages.items_current)
	
	# Check behavior based on current animation
	if anim.current_animation == "Destroy":
		collision_shape.disabled = true


func _on_Item_body_entered(body):
	if body.is_in_group("Player"):
		print("collected")
#		emit_signal("collected")
		
		# Player Items
		if body.inventory.has("bat"):
			body.current_bat_flap = body.bat_flap
		
		# Player invincibility
		body.invincible = true
		body.invincibility_timer.start()
		
		# Attacks
		body.can_attack_boost = true
		body.set_physics_process(false)
		
		# HUD
		itemhud.slots[itemhud.current_slots].texture = ItemAndStages.item_sprites[item_index]
		itemhud.current_slots += 1 
		
		# Inventory
		body.inventory.append(item_selected)
		
		ItemAndStages.item_sprites.remove(item_index)
		ItemAndStages.items_current.remove(item_index)
		
		# Stages
		ItemAndStages.next_stage = ItemAndStages.intensity_1_stages[randi() % ItemAndStages.intensity_1_stages.size()]
		
		get_parent().get_parent().all_enemies_gone_called = true
		get_parent().get_parent().stage_shift(ItemAndStages.next_stage)
		queue_free()

func discard():
	# Spit
	var this_discarded_item = discarded_item.instance()
	
	this_discarded_item.position = global_position
	this_discarded_item.sprite.texture = sprite.texture
	get_parent().add_child(this_discarded_item)
	
	# Leave
	queue_free()

func _on_Item_collected():
	print("guess not me!!")
#
#	collision_shape.disabled = true
#
#	anim.stop()
#	anim.play("Destroy")
#	queue_free()
