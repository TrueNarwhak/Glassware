extends Node2D

onready var item_hud = get_parent().get_node("ItemHud")

onready var anim = $AnimationPlayer
onready var slot_large0 = $Recipt/Slots/SlotLarge0
onready var slot_large1 = $Recipt/Slots/SlotLarge1
onready var slot_large2 = $Recipt/Slots/SlotLarge2

onready var stages_cleared_num = $Recipt/Score/StagesClearedNum

func _ready():
	anim.play("ComeIn")
	
	slot_large0.texture = item_hud.slot0.texture
	slot_large1.texture = item_hud.slot1.texture
	slot_large2.texture = item_hud.slot2.texture
	
	stages_cleared_num.text = str(ItemAndStages.stages_cleared)

func _process(delta):
	if Input.is_action_just_pressed("restart") and can_restart():
		get_tree().reload_current_scene()
		ItemAndStages.reset_all()
#		get_tree().change_scene("res://rooms/Menus/Quote.tscn")

func can_restart():
	return true
