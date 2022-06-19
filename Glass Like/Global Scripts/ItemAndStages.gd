extends Node

# Items
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
var last_stage = ""

onready var intensity_1_stages = [
	load("res://rooms/stages/StagePlatesLayer.tscn"),
	load("res://rooms/stages/StageChampaignIsland.tscn"),
	load("res://rooms/stages/StagePlatCover.tscn"),
	load("res://rooms/stages/StageRamp.tscn"),
	load("res://rooms/stages/StageGridBoard.tscn"),
	load("res://rooms/stages/StageBookRoll.tscn"),
	load("res://rooms/stages/StageDoubleMovePlat.tscn"),
	load("res://rooms/stages/StageTwoLamps.tscn"),
	load("res://rooms/stages/StageJumpOffLamp.tscn"),
	load("res://rooms/stages/StageBookRoll.tscn"),
	load("res://rooms/stages/StageCrumblePlate.tscn"),
#	load("res://rooms/stages/StageLampOverhead.tscn")
	
]

onready var intensity_2_stages = [
	
]

onready var intensity_3_stages = [
	
]

onready var next_stage = intensity_1_stages[randi() % intensity_1_stages.size()]

# Logic
var stages_cleared = 0

func _ready():
	randomize()

func reset_all():
	stages_cleared = -1
	
	items_current = ["anvil", "baseball", "bat", "floppydisk", "frog", "ghost", "jack",
	"marlin", "mushroom", "pin", "seal", "tnt", "wateringcan"]
	
	item_sprites = [
		preload("res://images/Items/v2/Anvil.png"), preload("res://images/Items/v2/baseball.png"),
		preload("res://images/Items/v2/Bat.png"), preload("res://images/Items/v2/FloppyDisk.png"),
		preload("res://images/Items/v2/Frog.png"), preload("res://images/Items/v2/Ghost.png"), 
		preload("res://images/Items/v2/jack.png"), preload("res://images/Items/v2/Marlin.png"), 
		preload("res://images/Items/v2/Mushroom.png"), preload("res://images/Items/v2/Pin.png"), 
		preload("res://images/Items/v2/Seal.png"), preload("res://images/Items/v2/TnT.png"), 
		preload("res://images/Items/v2/WateringCan.png")
	]
