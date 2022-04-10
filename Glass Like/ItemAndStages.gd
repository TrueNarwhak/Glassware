extends Node

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
onready var intensity_1_stages = [
	load("res://rooms/stages/StageThreeKettles.tscn"),
	load("res://rooms/stages/StagePlatesLayer.tscn"),
	load("res://rooms/stages/StageChampaignIsland.tscn"),
	load("res://rooms/stages/StagePlatCover.tscn"),
	load("res://rooms/stages/StageRamp.tscn")
]

onready var intensity_2_stages = [
	
]

onready var intensity_3_stages = [
	
]

onready var next_stage = intensity_1_stages[randi() % intensity_1_stages.size()]

func _ready():
	randomize()
