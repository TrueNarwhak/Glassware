extends Area2D

onready var sprite = $Visual/Item
onready var anim_player = $AnimationPlayer

var item_index
var item_selected

# -------------------------------------------------------------------- #

# items
var item_sprites = [
	preload("res://images/Items/v2/Anvil.png"), preload("res://images/Items/v2/baseball.png"),
	preload("res://images/Items/v2/Bat.png"), preload("res://images/Items/v2/FloppyDisk.png"),
	preload("res://images/Items/v2/Frog.png"), preload("res://images/Items/v2/Ghost.png"), 
	preload("res://images/Items/v2/jack.png"), preload("res://images/Items/v2/Marlin.png"), 
	preload("res://images/Items/v2/Mushroom.png"), preload("res://images/Items/v2/Pin.png"), 
	preload("res://images/Items/v2/Seal.png"), preload("res://images/Items/v2/TnT.png"), 
	preload("res://images/Items/v2/WateringCan.png")
]

var items_current = ["anvil", "baseball", "bat", "floppydisk", "frog", "ghost", "jack",
	"marlin", "mushroom", "pin", "seal", "tnt", "wateringcan"]

# Stages
onready var next_stage = load("res://rooms/stages/StageThreeKettles.tscn")

onready var intensity_1_stages = [
	load("res://rooms/stages/StageThreeKettles.tscn"),
	load("")
]

# -------------------------------------------------------------------- #

func _ready():
	randomize()
	item_index = randi() % items_current.size()

	sprite.texture = item_sprites[item_index]
	item_selected = items_current[item_index]
	
#	print(items_current)
#	print(item_index)
#	print(item_selected)

func _process(delta):
	anim_player.play("Idle") 


func _on_Item_body_entered(body):
	if body.is_in_group("Player"):
		print("collected")
		
		# Attacks
		body.can_attack_boost = true
		body.set_physics_process(false)
		
		# Inventory
		body.inventory.append(item_selected)
		
		# PUT INTO GLOBAL 
#		item_sprites.remove(item_index)
#		items_current.remove(item_index)
		
		# Stages
		get_parent().all_enemies_gone_called = true
		get_parent().stage_shift(next_stage)
		queue_free()
