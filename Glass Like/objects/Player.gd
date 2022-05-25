# CONTROLLER BY HEARTBEAST
extends KinematicBody2D

export var TARGET_FPS = 60
export var ACCELERATION = 100
export var MAX_SPEED = 335
export var FRICTION = 7
export var AIR_RESISTANCE = 1
export var GRAVITY = 21
export var JUMP_FORCE = 393
export var attack_force = 700

export var death_jump = 600

export(PackedScene) var attack
export(PackedScene) var shard 

export(PackedScene) var stats

var is_attacking = false
var can_attack_boost = true
var motion = Vector2.ZERO
var beachball_count = 0
var jump_death_called = false
var invincible = false

var x_input

onready var sprite = $AnimatedSprite
onready var feet_pos = $FeetPos
onready var ball_aim_pos = $BallAimPos
onready var death_timer = $DeathTimer
onready var invincibility_timer = $InvincibilityTimer
onready var drop_cast = $DropCast

onready var bat_wings = $BatWings
onready var baseball_bat = $AnimatedSprite/BaseballBat

onready var camera = get_parent().get_node("LeanCamera")

# ------------------------------------ #

var inventory = []
var inventory_max = 3

export var mushroom_force = 800
export var frog_jump = 400
export var frog_hinder = 104
export var flower_slow = 35
export(PackedScene) var beachball
export(PackedScene) var flower
export(PackedScene) var anvil_stomp
export(PackedScene) var floppy_disk
onready var floppy_disk_exists = get_parent().has_node("Floppydisk")
export var anvil_gravity = 350
export var bat_flap = 536
var current_bat_flap = bat_flap
export var bat_decay = 5

# ------------------------------------ #

func ready():
	pass

func _physics_process(delta):
	
	# Get Inputs
	x_input = Input.get_action_strength("move_right") - int(jump_death_called) - Input.get_action_strength("move_left")
	var current_jump = JUMP_FORCE + frog_jump*int(inventory.has("frog"))
	
	var frog_current_hinder = (frog_hinder * int(inventory.has("frog"))) * int(!is_on_floor())
	
	# Physics
	if x_input != 0:
		motion.x += x_input * ACCELERATION * delta * TARGET_FPS
		motion.x = clamp(motion.x, -MAX_SPEED + frog_current_hinder, MAX_SPEED - frog_current_hinder)
		
		if !is_attacking: 
			sprite.playing = true
			sprite.play("Walk")
		else:
			sprite.playing = false
		
		if is_on_floor() and !jump_death_called:
			sprite.flip_h = x_input < 0
	else:
		sprite.playing = false
		if is_on_floor() and !is_attacking:
			sprite.play("default")
	
	# Apply Gravity
	motion.y += GRAVITY * delta * TARGET_FPS
	
	if is_on_floor():
		
		# If not moving
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION * delta)
		
		# Jumping
		if Input.is_action_just_pressed("jump"):
			motion.y = -current_jump
		
		# Attack boosting
		can_attack_boost = true
		
		# Items
#		current_bat_flap = bat_flap
	else:
		
		if Input.is_action_just_released("jump") and motion.y < -current_jump/2 and !is_attacking:
			motion.y = -current_jump/2
		
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta)
		
		# Animation
		if !is_attacking:
			if motion.y < 0:
				sprite.play("Jump")
			else:
				sprite.play("Fall")
	
	if jump_death_called:
		sprite.play("Shatter")
	
	# Dropping Through Platforms
	if drop_cast.is_colliding() and Input.is_action_just_pressed("move_down"):
		if drop_cast.get_collider().is_in_group("StageFallThrough") and drop_cast.get_collider().is_in_group("StageGround"):
			position.y += 1
	
	# Attacking
	if Input.is_action_just_pressed("attack") and !is_attacking and !jump_death_called:
		is_attacking = true
		
		var this_attack = attack.instance()
		add_child(this_attack)
		
		# Boosting
		if can_attack_boost and !is_on_floor():
			
			# Apply physics
			motion = attack_force * get_local_mouse_position().normalized()
			can_attack_boost = false
		else:
			
			# Apply physics
			motion.x = attack_force * get_local_mouse_position().normalized().x / 1.5
			can_attack_boost = false
			
			# Animation
			sprite.play("GroundAttack")
		
		# Seal
		beachball_count += 1
		if beachball_count > 1:
			beachball_count = 0
		
		if inventory.has("seal") and beachball_count == 1:
#		if inventory.has("seal"):
			var this_beachball = beachball.instance()
			this_beachball.global_position = ball_aim_pos.global_position
			get_parent().add_child(this_beachball)
		
		# Baseball
		if inventory.has("baseball"):
			baseball_bat.frame += 1
			
			if baseball_bat.frame == 2:
				baseball_bat.frame = 0
	
	# Apply physics
	motion = move_and_slide(motion, Vector2.UP)
	
	# Items -------
	# Anvil
	if inventory.has("anvil") and !is_on_floor() and !jump_death_called:
		if Input.is_action_pressed("move_down"):
			motion.y += anvil_gravity * delta * TARGET_FPS
	
	# Bat
	if inventory.has("bat"):
		if Input.is_action_pressed("jump") and current_bat_flap != 0:
			motion.y = -current_bat_flap
			
			current_bat_flap -= bat_decay * delta * TARGET_FPS
			current_bat_flap = clamp(current_bat_flap, 0, 100000000000)
	
	bat_wings.visible = bool(int(Input.is_action_pressed("jump")) * int(current_bat_flap != 0) * int(inventory.has("bat")))
	
	# Baseball
	baseball_bat.visible = bool(int(inventory.has("baseball")) * int(!is_attacking))
	baseball_bat.flip_h = sprite.flip_h
	
	if !baseball_bat.flip_h:
		baseball_bat.position.x = -55
	else:
		baseball_bat.position.x = 55
		
	
	# Floppy disk
	floppy_disk_exists = get_parent().has_node("Floppydisk")
	
	if inventory.has("floppydisk") and !floppy_disk_exists:
		if Input.is_action_just_pressed("move_down"):
			var this_disk = floppy_disk.instance()
			
			this_disk.position = global_position
			get_parent().add_child(this_disk)

# ---------------------------------------------------------------- #

func _on_MushroomStomp_body_entered(body):
	
	# Mushroom
	if inventory.has("mushroom") and body.get_parent().is_in_group("Enemies") and !is_on_floor():
		body.get_parent().survive -= 1
		print("stomp!")
		motion.y = -mushroom_force
	
	# Anvil
	if inventory.has("anvil") and Input.is_action_pressed("move_down") and body.is_in_group("StageGround"):
		var this_stomp = anvil_stomp.instance()
		this_stomp.global_position.x = get_global_position().x
		this_stomp.global_position.y = get_global_position().y + 25
		get_parent().add_child(this_stomp)
		
		if body.get_parent().is_in_group("Enemies"):
			body.get_parent().survive -= 1


func _on_WateringCanTimer_timeout():
	if inventory.has("wateringcan") and is_on_floor() and !x_input == 0:
		var this_flower = flower.instance()
		this_flower.global_position = feet_pos.get_global_position()
		get_parent().add_child(this_flower)

# ---------------------------------------------------------------- #

func _on_DeathTimer_timeout():
	set_process(false)
	set_physics_process(false)
	visible = false
	
	for i in 6:
		var this_shard = shard.instance()
		this_shard.position = get_global_position()
		get_tree().get_root().add_child(this_shard)
	
	$StatTimer.start()

func _on_StatTimer_timeout():
	var these_stats = stats.instance()
	these_stats.global_position = Vector2(0, 0)
	get_parent().add_child(these_stats)


func _on_invincibilityTimer_timeout():
	invincible = false


func shatter():
	print("Shxrch!")
	
	if !invincible:
		# Camera
		if !jump_death_called:
			camera.zoom = Vector2(camera.player_death_pop, camera.player_death_pop)
		
		# Die
		if !jump_death_called:
			motion.y = -death_jump
			
			death_timer.start()
			
			jump_death_called = true




