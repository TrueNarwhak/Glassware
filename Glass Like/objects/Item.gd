extends Area2D

onready var sprite = $Visual/Item
onready var anim_player = $AnimationPlayer

signal collected

var item_sprites = [preload("res://images/Items/baseballbat.png"), preload("res://images/Items/bat.png"), 
					preload("res://images/Items/frog2.png"), preload("res://images/Items/ghost.png"),
					preload("res://images/Items/leprechaun.png"), preload("res://images/Items/marlin.png"),
					preload("res://images/Items/mushroom.png"), preload("res://images/Items/seal.png"),
					preload("res://images/Items/waterbucket.png")]

onready var next_stage = load("res://rooms/stages/StageThreeKettles.tscn")

onready var intensity_1_stages = [
	load("res://rooms/stages/StageThreeKettles.tscn"),
	load("")
]

func _ready():
	randomize()
	var item_index = randi() % 9
	sprite.texture = item_sprites[item_index]


func _process(delta):
	anim_player.play("Idle") 


func _on_Item_body_entered(body):
	if body.is_in_group("Player"):
		print("collected")
		emit_signal("collected")
		get_parent().all_enemies_gone_called = true
		get_parent().stage_shift(next_stage)
		queue_free()
