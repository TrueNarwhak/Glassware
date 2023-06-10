extends Node

# Items
var item_sprites = [
	preload("res://images/Items/v2/Anvil.png"), preload("res://images/Items/v2/baseball.png"),
	preload("res://images/Items/v2/Bat.png"),
	preload("res://images/Items/v2/Frog.png"), preload("res://images/Items/v2/Ghost.png"), 
	preload("res://images/Items/v2/Octopus.png"), preload("res://images/Items/v2/Bull.png"), 
	preload("res://images/Items/v2/Mushroom.png"), preload("res://images/Items/v2/Pin.png"), 
	preload("res://images/Items/v2/Seal.png"), preload("res://images/Items/v2/TnT.png"), 
	preload("res://images/Items/v2/WateringCan.png")
]

var items_current = ["anvil", "baseball", "bat", "frog", "ghost", "octopus",
	"bull", "mushroom", "pin", "seal", "tnt", "wateringcan"]

var item_tooltips = [
	"Press down midair to slam down,\nbreaking foes, ..but you may lose control", 
	"Swing a heavy baseball\nbat that reflects proectiles",
	"Replace your jump with flight\n...but it lasts only a little each stage",
	"Protect your extra high jump with\na lilipad! ...But you're pretty slow in the air",
	"Breaking foes summon ghosts! They'll attack\nthem, but grow vengeful if left without enemies...",
	"Grow Tentacles! They'll attack anything near you.\nSticky cups might pull you around though...",
	"Hold left AND right to charge an\nuncontrollable thrust toward the cursor!",
	"Yahoo! Jump on foes heads\nto break them to bits",
	"A pin, that can break foes OR you, will fall\non vanquishing a foe. Hitting it gives you a boost",
	"Throw beach balls every other attack!\nBoing, boing, boing, they'll bounce you too!",
	"Breaking foes throws an\nexplosive. Pow!",
	"Plant Sprouts with every step! They're slow\nto walk through BUT hitting them causes them to bloom"
]

# Stages
var last_stage = ""

onready var intensity_1_stages = [
	load("res://rooms/stages/StagePlateTwoSide.tscn"),
	load("res://rooms/stages/StageBookTower.tscn"),
	load("res://rooms/stages/StageMovingTrinkets.tscn"),
	load("res://rooms/stages/StageMovingTeacups.tscn"),
	load("res://rooms/stages/StageTwoColumns.tscn"),
	load("res://rooms/stages/StageLampJungle.tscn")
]

onready var intensity_2_stages = [
	load("res://rooms/stages/StagePlatesLayer.tscn"),
	load("res://rooms/stages/StageChampaignIsland.tscn"),
	load("res://rooms/stages/StagePlatCover.tscn"),
	load("res://rooms/stages/StageRamp.tscn"),
	load("res://rooms/stages/StageGridBoard.tscn"),
	load("res://rooms/stages/StageBookRoll.tscn"),
	load("res://rooms/stages/StageDoubleMovePlat.tscn"),
#	load("res://rooms/stages/StageTwoLamps.tscn"),
	load("res://rooms/stages/StageJumpOffLamp.tscn"),
	load("res://rooms/stages/StageBookRoll.tscn"),
	load("res://rooms/stages/StageChampaignJump.tscn")
#	load("res://rooms/stages/StageCrumblePlate.tscn"),
#	load("res://rooms/stages/StageLampOverhead.tscn")
]

onready var next_stage = intensity_1_stages[randi() % intensity_1_stages.size()]

const SAVE_FILE_PATH = "user://savedata.save"

# Logic
var stages_cleared = 0
var highscore_stages_cleared = 0

func _ready():
	randomize()
	load_highscore()

func reset_all():
	
	print(highscore_stages_cleared)
	
	# Rest
	stages_cleared = -1
	
	items_current = ["anvil", "baseball", "bat", "frog", "ghost", "octopus",
	"bull", "mushroom", "pin", "seal", "tnt", "wateringcan"]
	
	item_sprites = [
		preload("res://images/Items/v2/Anvil.png"), preload("res://images/Items/v2/baseball.png"),
		preload("res://images/Items/v2/Bat.png"),
		preload("res://images/Items/v2/Frog.png"), preload("res://images/Items/v2/Ghost.png"), 
		preload("res://images/Items/v2/Octopus.png"), preload("res://images/Items/v2/Bull.png"), 
		preload("res://images/Items/v2/Mushroom.png"), preload("res://images/Items/v2/Pin.png"), 
		preload("res://images/Items/v2/Seal.png"), preload("res://images/Items/v2/TnT.png"), 
		preload("res://images/Items/v2/WateringCan.png")
	]
	
	item_tooltips = [
		"Press down midair to slam down,\nbreaking foes, ..but you may lose control", 
		"Swing a heavy baseball\nbat that reflects proectiles",
		"Replace your jump with flight\n...but it lasts only a little each stage",
		"Protect your extra high jump with\na lilipad! ...But you're pretty slow in the air",
		"Breaking foes summon ghosts! They'll attack\nthem, but grow vengeful if left without enemies...",
		"Grow Tentacles! They'll attack anything near you.\nSticky cups might pull you around though...",
		"Hold left AND right to charge an\nuncontrollable thrust toward the cursor!",
		"Yahoo! Jump on foes heads\nto break them to bits",
		"A pin, that can break foes OR you, will fall\non vanquishing a foe. Hitting it gives you a boost",
		"Throw beach balls every other attack!\nBoing, boing, boing, they'll bounce you too!",
		"Breaking foes throws an\nexplosive. Pow!",
		"Plant Sprouts with every step! They're slow\nto walk through BUT hitting them causes them to bloom"
	]
	

func update_highscore():
	
	# Higschore
	if stages_cleared > highscore_stages_cleared:
		highscore_stages_cleared = stages_cleared
		save_highscore()


func save_highscore():
	var save_data = File.new()
	save_data.open(SAVE_FILE_PATH, File.WRITE)
	save_data.store_var(highscore_stages_cleared)
	save_data.close()

func load_highscore():
	
	var save_data = File.new()
	
	if save_data.file_exists(SAVE_FILE_PATH):
		save_data.open(SAVE_FILE_PATH, File.READ)
		highscore_stages_cleared = save_data.get_var()
		save_data.close()
