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

var item_tooltips = [
	"Press down midair to slam down,\nbreaking foes, ..but you may lose control", 
	"Swing a heavy baseball\nbat that reflects proectiles",
	"Replace your jump with flight\n...but it lasts only a little each stage",
	"default text :OOOOO\n noway",
	"Jump twice as fast, and twice as\nhigh. ...But, you move slow in the air",
	"Breaking foes summons ghosts that will\nattack others. ..Though, they grow restless",
	"default text :OOOO\n no way",
	"default text :OOOO\n no way",
	"Yahoo! Jump on foes heads\nto break them to bits",
	"A pin, that can break foes OR you, will fall\non vanquish of a foe. Hitting it gives a boost",
	"Throw beach balls every other attack!\nBoing, boing, boing, they'll bounce you too!",
	"Breaking foes throws an\nexplosive. Pow!",
	"default text :OOOO\n no way"
]

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
#	load("res://rooms/stages/StageTwoLamps.tscn"),
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
	
	item_tooltips = [
		"Press down midair to slam down,\nbreaking foes, ..but you may lose control", 
		"Swing a heavy baseball\nbat that reflects proectiles",
		"Replace your jump with flight\n...but it lasts only a little each stage",
		"default text :OOOOO\n noway",
		"Jump twice as fast, and twice as\nhigh. ...But, you move slow in the air",
		"Breaking foes summons ghosts that will\nattack others. ..Though, they grow restless",
		"default text :OOOO\n no way",
		"default text :OOOO\n no way",
		"Yahoo! Jump on foes heads\nto break them to bits",
		"A pin, that can break foes OR you, will fall\non vanquish of a foe. Hitting it gives a boost",
		"Throw beach balls every other attack!\nBoing, boing, boing, they'll bounce you too!",
		"Breaking foes throws an\nexplosive. Pow!",
		"default text :OOOO\n no way"
	]
