extends Area2D

onready var sprite = $Visual/Item
onready var anim_player = $AnimationPlayer
onready var collision_shape = $CollisionShape2D

onready var itemhud = get_parent().get_parent().get_node("ItemHud")

var item_index
var item_selected

signal collected

# -------------------------------------------------------------------- #

func _ready():
	randomize()
	item_index = randi() % ItemAndStages.items_current.size()

	sprite.texture = ItemAndStages.item_sprites[item_index]
	item_selected = ItemAndStages.items_current[item_index]
	
	anim_player.play("Idle") 
	
	self.connect("collected", self, "_on_Item_collected")
#	print(items_current)
#	print(item_index)
#	print(item_selected)

func _process(delta):
	pass


func _on_Item_body_entered(body):
	if body.is_in_group("Player"):
		print("collected")
		emit_signal("collected")
		
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
		
		get_parent().all_enemies_gone_called = true
		get_parent().stage_shift(ItemAndStages.next_stage)
		queue_free()


func _on_Item_collected(node):
	print("guess not me!!")
	
	collision_shape.disabled = true
	
	anim_player.stop()
	anim_player.play("Destroy")
	queue_free()
