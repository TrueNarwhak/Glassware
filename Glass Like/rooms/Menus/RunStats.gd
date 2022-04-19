extends Node2D

onready var item_hud = get_parent().get_node("ItemHud")

onready var anim = $Control/AnimationPlayer
onready var slot_large0 = $Control/FadeIn/SlotLarge0
onready var slot_large1 = $Control/FadeIn/SlotLarge1
onready var slot_large2 = $Control/FadeIn/SlotLarge2

var can_respawn = false

func _ready():
	anim.play("ComeIn")
	
	slot_large0.texture = item_hud.slot0.texture
	slot_large1.texture = item_hud.slot1.texture
	slot_large2.texture = item_hud.slot2.texture

func _process(delta):
	if Input.is_action_just_pressed("restart") and can_respawn:
		get_tree().reload_current_scene()


func _on_AnimationPlayer_animation_finished(anim_name):
	can_respawn = true
