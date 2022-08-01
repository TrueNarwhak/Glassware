extends Area2D

onready var sprite = $Visual/Item
onready var anim = $AnimationPlayer
onready var collision_shape = $CollisionShape2D

onready var anim_tooltip = $TooltipArea/TooltipAnim
onready var tooltip_holder = $TooltipArea/TooltipHolder
onready var tooltip = $TooltipArea/TooltipHolder/Label

onready var oooo_sound = $ooooooo

onready var player = get_parent().get_parent().get_parent().get_node("Player")

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
	tooltip.text = ItemAndStages.item_tooltips[item_index]
	
	# Sound
	oooo_sound.play()
	
	# Start anim
	anim.play("Idle")
#	print(items_current)
#	print(item_index)
#	print(item_selected)

func _exit_tree():
	get_parent().get_parent().get_parent().get_node("HerFoyer").bus = "Music"


func _process(delta):
#	print(ItemAndStages.items_current)
	
	# Check behavior based on current animation
	if anim.current_animation == "Destroy":
		collision_shape.disabled = true
	
	if is_inside_tree():
		get_parent().get_parent().get_parent().get_node("HerFoyer").bus = "MuffledMusic"
	
	# Player Items
#	if visible and player.inventory.has("bat"):
#		player.current_bat_flap = player.bat_flap

func _on_Item_body_entered(body):
	if body.is_in_group("Player"):
		if body.inventory.size() != 3: 
			print("collected")
	#		emit_signal("collected")
			
			# Player Items
			if body.inventory.has("bat"):
				body.current_bat_flap = body.bat_flap
			
			# Player invincibility
			if body.invincibility_timer.is_stopped():
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
			ItemAndStages.item_tooltips.remove(item_index)
			
			# Stages
			ItemAndStages.next_stage = ItemAndStages.intensity_1_stages[randi() % ItemAndStages.intensity_1_stages.size()]
			
			get_parent().get_parent().all_enemies_gone_called = true
			get_parent().get_parent().stage_shift(ItemAndStages.next_stage)
			queue_free()
		else:
			discard()

func _on_TooltipArea_body_entered(body):
	if body.is_in_group("Player"):
		anim_tooltip.play("TooltipPop")

func _on_TooltipArea_area_exited(area):
	tooltip_holder.hide()

func discard():
	# Spit
	collision_shape.disabled = true
	var this_discarded_item = discarded_item.instance()
	
	this_discarded_item.position = position
	this_discarded_item.await_texture = sprite.texture
	get_parent().get_parent().get_parent().add_child(this_discarded_item)
	
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
