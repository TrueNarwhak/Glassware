extends KinematicBody2D

onready var player = get_parent().get_node("Player")

onready var anim = $AnimationPlayer
onready var sprite = $Sprite
onready var star_sprite = $StarSprite
onready var spawn_timer = $SpawnTimer
export(PackedScene) var disperse_cloud

export var look_spawned = 28
export var clamped_look_top = -18
export var clamped_look_bottom = 18

export var evil_red        = 20
export var evil_red_speed  = 0.05 
export var ally_move_speed = 5
export var foe_move_speed  = 7

enum {
	SPAWNED,
	ALLY,
	MORAL_SHIFT,
	FOE
}

var TARGET_FPS = 60
var nearest_enemies = []
var state  = SPAWNED
var motion = Vector2(0,0)

# -------------------------------------- #

func _ready():
	pass

func _physics_process(delta):
	
	match state:
		SPAWNED:
			
			# Visual
			anim.play("Star")
		
		ALLY:
			# Visual
			anim.play("Flicker")
			
			sprite.look_at(player.position)
			sprite.rotation_degrees = clamp(sprite.rotation_degrees, clamped_look_top, clamped_look_bottom)
			
			
			if nearest_enemies.size() != 0:
				
				var nearest_enemy = nearest_enemies[0].body
				
				# Move to nearest enemy
				var direction_to_nearest_enemy = global_transform.origin.direction_to(nearest_enemy.global_transform.origin)
				motion = direction_to_nearest_enemy * ally_move_speed * delta * TARGET_FPS
				
				# Apply Motion
				motion = move_and_collide(motion)
				
				# Flip
				if player.position.x - position.x > 0:
					sprite.flip_h = true
				else:
					sprite.flip_h = false
			else:
				state =  MORAL_SHIFT
			
		
		MORAL_SHIFT:
			# Visual
			anim.play("Moral Shift")
			
			sprite.modulate.a      = move_toward(sprite.modulate.a,      evil_red, evil_red_speed)
			star_sprite.modulate.a = move_toward(star_sprite.modulate.a, evil_red, evil_red_speed)
			sprite.flip_h = false
			
		
		FOE:
			
			# Visual
			sprite.look_at(player.position)
			sprite.rotation_degrees = clamp(sprite.rotation_degrees, clamped_look_top, clamped_look_bottom)
			
			# Move to nearest enemy
			var direction_to_player = global_transform.origin.direction_to(player.global_transform.origin)
			motion = direction_to_player * foe_move_speed * delta * TARGET_FPS
			
			# Apply Motion
			motion = move_and_collide(motion)
			
			# Flip
			if player.position.x - position.x > 0:
				sprite.flip_h = false
			else:
				sprite.flip_h = true

func disperse():
	var this_disperse = disperse_cloud.instance()
	this_disperse.position   = position
	
	get_parent().add_child(this_disperse)
	
	queue_free()


func _on_EnemyDetectArea_body_entered(body):
	var this_body = body.get_parent()
	
	if this_body.is_in_group("Enemies"):
		nearest_enemies.append(this_body)


func _on_EnemyDetectArea_body_exited(body):
	var this_body = body.get_parent()
	
	if this_body.is_in_group("Enemies"):
		nearest_enemies.erase(this_body)



func _on_SpawnTimer_timeout():
	state = ALLY
	print("bazinga!")



func _on_Hitbox_body_entered(body):
	var this_body = body.get_parent()
	
	if state == ALLY:
		if this_body.is_in_group("Enemies"):
			this_body.survive -= 1
			disperse()
	
	if state == FOE:
		if body.is_in_group("Player"):
			body.shatter()
			disperse()




func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Moral Shift":
		state = FOE
