extends Node2D

onready var item_hud = get_parent().get_node("ItemHud")

onready var anim = $Control/AnimationPlayer
onready var slot_large0 = $Control/FadeIn/SlotLarge0
onready var slot_large1 = $Control/FadeIn/SlotLarge1
onready var slot_large2 = $Control/FadeIn/SlotLarge2

onready var stages_cleared_num = $Control/FadeIn2/StagesClearedNum

var can_respawn = false

func _ready():
	anim.play("ComeIn")
	
	slot_large0.texture = item_hud.slot0.texture
	slot_large1.texture = item_hud.slot1.texture
	slot_large2.texture = item_hud.slot2.texture
	
	stages_cleared_num.text = str(ItemAndStages.stages_cleared)

func _process(delta):
	if Input.is_action_just_pressed("restart") and can_respawn:
		get_tree().reload_current_scene()
		ItemAndStages.reset_all()

func set_respawn_ability():
	can_respawn = true
