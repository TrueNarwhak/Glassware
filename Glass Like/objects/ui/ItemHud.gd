extends Node2D

onready var player = get_parent().get_node("Player")

onready var slot0 = $Slot0
onready var slot1 = $Slot1
onready var slot2 = $Slot2

onready var slots = [slot0, slot1, slot2]
onready var current_slots = 0

func _ready():
	pass

func _process(delta):
	pass

func amievenreal():
	print("maybe i am")
