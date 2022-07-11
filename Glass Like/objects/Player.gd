# BASE CONTROLLER BY HEARTBEAST, ALL OF THE EXTRA STUFF BY ME LOL
extends KinematicBody2D

export var TARGET_FPS = 60
export var ACCELERATION = 100
export var default_max_speed = 414
export var FRICTION = 7
export var AIR_RESISTANCE = 1
export var GRAVITY = 21
export var JUMP_FORCE = 393
export var attack_force = 700

export var death_jump = 600

export(PackedScene) var attack
export(PackedScene) var shard 

export(PackedScene) var stats

var MAX_SPEED = default_max_speed
var is_attacking = false
var can_attack_boost = true
var motion = Vector2.ZERO
var beachball_count = 0
var jump_death_called = false
var invincible = false

var x_input

onready var sprite = $AnimatedSprite
onready var feet_pos = $FeetPos
onready var drop_cast = $DropCast
onready var death_effect = $DeathEffect

onready var ball_aim_pos = $BallAimPos
onready var bull_pos_holder = $AnimatedSprite/BullPosHolder

onready var death_timer = $Timers/DeathTimer
onready var invincibility_timer = $Timers/InvincibilityTimer
onready var stat_timer = $Timers/StatTimer
onready var bull_charge_timer = $Timers/BullChargeTimer
onready var bull_recover_timer = $Timers/BullRecoverTimer
onready var seal_timer = $Timers/SealTimer

onready var bat_wings = $BatWings
onready var baseball_bat = $AnimatedSprite/BaseballBat

onready var camera = get_parent().get_node("LeanCamera")

# ------------------------------------ #

var inventory = []
var inventory_max = 3

var can_seal = true

export var mushroom_force = 800

export var frog_jump = 473
export var frog_hinder = 174
export var flower_slow = 35

export var watering_can_offset = 16

export var bull_boost_ground = 1000
export var bull_boost_air = 300
export var bull_knock_x = 200
export var bull_knock_y = 200
var bull_ramming = false

export(PackedScene) var beachball
export(PackedScene) var flower
export(PackedScene) var anvil_stomp
export(PackedScene) var floppy_disk
export(PackedScene) var lilipad
export(PackedScene) var bull_star
export(PackedScene) var tentacle_holder

onready var floppy_disk_exists = get_parent().has_node("Floppydisk")

export var anvil_gravity = 350

export var bat_flap = 736
var current_bat_flap = bat_flap
export var bat_decay = 5
export var min_bat_flap = 5

export var tentacle_holder_size = Vector2(2.452, 2.452)

# ------------------------------------ #

func ready():
	pass

func _physics_process(delta):
	
	# Get Inputs
	if !jump_death_called and !bull_ramming:
		x_input = Input.get_action_strength("move_right") - int(jump_death_called) - Input.get_action_strength("move_left")
	
	var current_jump = JUMP_FORCE + frog_jump*int(inventory.has("frog"))
	
	var frog_current_hinder = (frog_hinder * int(inventory.has("frog"))) * int(!is_on_floor())
	
	# Physics
	if x_input != 0:
		motion.x += x_input * ACCELERATION * delta * TARGET_FPS
		motion.x = clamp(motion.x, -MAX_SPEED + frog_current_hinder, MAX_SPEED - frog_current_hinder)
		
		if !is_attacking and !bull_ramming: 
			sprite.playing = true
			sprite.play("Walk")
		else:
			sprite.playing = false
		
		if is_on_floor() and !jump_death_called:
			sprite.flip_h = x_input < 0
	else:
		sprite.playing = false
		if is_on_floor() and !is_attacking and !bull_ramming:
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
			
			frog_item(delta)
		
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
		if !is_attacking and !bull_ramming:
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
			if is_on_floor(): sprite.play("GroundAttack")
		
		# Items
		seal_item_attack()
		
		baseball_item_attack()
	
	# Apply physics
	motion = move_and_slide(motion, Vector2.UP)
	
	# Items 
	anvil_item(delta)
	
	bat_item(delta)
	
	baseball_item()
	
	floppy_disk_item()
	
	bull_item(delta)
	
	octopus_item()
	

# ---------------------------------------------------------------- #

func seal_item_attack():
#	beachball_count += 1
#	if beachball_count > 1:
#		beachball_count = 0
	
	if inventory.has("seal") and can_seal:
#		if inventory.has("seal"):
		var this_beachball = beachball.instance()
		this_beachball.position = ball_aim_pos.global_position
		get_parent().add_child(this_beachball)
	
	# Set Attack Vars
	can_seal = false
	
	if seal_timer.time_left == 0:
		seal_timer.start()


func frog_item(delta):
	if inventory.has("frog"):
		var this_lilipad = lilipad.instance()
		
		this_lilipad.position = Vector2(-500, -500)
		get_parent().add_child(this_lilipad)


func mushroom_item_stomp(body):
	# Mushroom
	if inventory.has("mushroom") and body.get_parent().is_in_group("Enemies") and !is_on_floor():
		body.get_parent().survive -= 1
		print("stomp!")
		motion.y = -mushroom_force


func anvil_item(delta):
	if inventory.has("anvil") and !is_on_floor() and !jump_death_called:
		if Input.is_action_pressed("move_down"):
			motion.y += anvil_gravity * delta * TARGET_FPS

func anvil_item_stomp(body):
	if inventory.has("anvil") and Input.is_action_pressed("move_down"):
		
		# Normal Break
		if body.get_parent().is_in_group("Enemies"):
			body.get_parent().survive -= 1
		
		# Create Shockwave
		if body.is_in_group("StageGround"):
			var this_stomp = anvil_stomp.instance()
			this_stomp.position.x = get_global_position().x
			this_stomp.position.y = get_global_position().y + 25
			get_parent().add_child(this_stomp)


func bat_item(delta):
	if inventory.has("bat"):
		if Input.is_action_pressed("jump") and current_bat_flap != 0:
			motion.y = -current_bat_flap
			
			current_bat_flap -= bat_decay * delta * TARGET_FPS
			current_bat_flap = clamp(current_bat_flap, min_bat_flap, 99999)
	
	bat_wings.visible = bool(int(Input.is_action_pressed("jump")) * int(current_bat_flap != 0) * int(inventory.has("bat")))
	
	bat_wings.modulate.r = darken_bat_wings()
	bat_wings.modulate.g = darken_bat_wings()
	bat_wings.modulate.b = darken_bat_wings()



func baseball_item_attack():
	if inventory.has("baseball"):
		baseball_bat.frame += 1
		
		if baseball_bat.frame == 2:
			baseball_bat.frame = 0

func baseball_item():
	baseball_bat.visible = bool(int(inventory.has("baseball")) * int(!is_attacking))
	baseball_bat.flip_h = sprite.flip_h
	
	if !baseball_bat.flip_h:
		baseball_bat.position.x = -55
	else:
		baseball_bat.position.x = 55



func floppy_disk_item():
	floppy_disk_exists = get_parent().has_node("Floppydisk")
	
	if inventory.has("floppydisk") and !floppy_disk_exists:
		if Input.is_action_just_pressed("move_down"):
			var this_disk = floppy_disk.instance()
			
			this_disk.position = global_position
			get_parent().add_child(this_disk)


func bull_item(delta):
	# LMAO I FIXED THE BULL ITEM BY MAKING THE TIMER SHORT AND REMOVING JUST_PRESSED CHECK
	# ok "charge timer" is like time til start ram now
	
	if inventory.has("bull"):
		
		# Change area direction
		if position.x - get_global_mouse_position().x > 0:
			bull_pos_holder.scale.x = -1
		else:
			bull_pos_holder.scale.x = 1
		
#		print(bull_charge_timer.time_left)
#		print(bull_ramming)
		
		# Begin Charge 
		if Input.is_action_pressed("move_left") and Input.is_action_pressed("move_right"):
			bull_charge_timer.start()
			
			if !jump_death_called:
				sprite.play("BullRam")
				sprite.frame = 0
		
		# If charging
		if bull_charge_timer.time_left > 0:
			bull_ramming = true
			
			# Cancel Charge if not pressing	
#			if Input.is_action_just_released("move_left") and !Input.is_action_just_released("move_right"):
#				bull_charge_timer.stop()
#				bull_ramming = false
			
			# Change anim frame
			sprite.frame = 0
		
		# If recovering
		if bull_recover_timer.time_left > 0:
			# Play anim
			sprite.frame = 1
		
		
		# Play anim
		if bull_ramming:
			sprite.play("BullRam")
			
			if bull_pos_holder.scale.x == 1:
				sprite.flip_h = false
			else:
				sprite.flip_h = true


func octopus_item():
	if inventory.has("octopus"):
		
		# Place Tentacles
		if !get_node("TentacleHolder"):
			var this_tentacle_holder = tentacle_holder.instance()
#			this_tentacle_holder.position = position
			this_tentacle_holder.scale = tentacle_holder_size
			
			add_child(this_tentacle_holder)

# ---------------------------------------------------------------- #

func darken_bat_wings():
	var mod_prop = 1.0
	
	mod_prop = current_bat_flap / bat_flap * 1
	mod_prop = clamp(mod_prop, 0.3, 1.0)
	
	return mod_prop

# ---------------------------------------------------------------- #

func _on_MushroomStomp_body_entered(body):
	mushroom_item_stomp(body)
	anvil_item_stomp(body)


func _on_WateringCanTimer_timeout():
	if inventory.has("wateringcan") and is_on_floor() and !x_input == 0:
		var this_flower = flower.instance()
		
		if sprite.flip_h:
			this_flower.position.x = feet_pos.get_global_position().x + watering_can_offset
		else:
			this_flower.position.x = feet_pos.get_global_position().x - watering_can_offset		
		
		this_flower.position.y = feet_pos.get_global_position().y
		get_parent().add_child(this_flower)

# ---------------------------------------------------------------- #

func _on_DeathTimer_timeout():
	set_process(false)
	set_physics_process(false)
	visible = false
	
	for i in 6:
		var this_shard = shard.instance()
		this_shard.position = get_global_position()
		get_parent().add_child(this_shard)
	
	stat_timer.start()

func _on_StatTimer_timeout():
	var these_stats = stats.instance()
	these_stats.position = Vector2(0, 0)
	get_parent().add_child(these_stats)


func _on_invincibilityTimer_timeout():
	invincible = false


func _on_SealTimer_timeout():
	can_seal = true



func _on_BullChargeTimer_timeout():
	if inventory.has("bull"):
		if is_on_floor():
			motion.x = bull_boost_ground * bull_pos_holder.scale.x
		else:
			motion.x = bull_boost_air * bull_pos_holder.scale.x
	
	bull_recover_timer.start()

func _on_BullRecoverTimer_timeout():
	if inventory.has("bull"):
		sprite.play("default")
		
		bull_ramming = false
		print("done ram")

func _on_BullHitbox_body_entered(body):
	var this_body = body.get_parent()
	
	if inventory.has("bull") and sprite.animation == "BullRam" and sprite.frame == 1:
		
		# Break enemy
		if this_body.is_in_group("Enemies"):
			this_body.survive -= 1
			
			# Bouce player
			bull_ramming = false
			
			# Make Star
#			var this_bull_star = bull_star.instance()
#			this_bull_star.position = position
#			get_parent().add_child(this_bull_star)



func _on_DeathEffect_animation_finished():
	death_effect.visible = false

func shatter():
	print("Shxrch!")
	
	if !invincible:
		# Camera
		if !jump_death_called:
			camera.zoom = Vector2(camera.player_death_pop, camera.player_death_pop)
			camera.rotation_degrees = [camera.rotate_shake, -camera.rotate_shake][randi() % 2]

		# Play Effect 
		death_effect.visible = true
		death_effect.play()
		
		# Die
		if !jump_death_called:
			motion.y = -death_jump
			
			death_timer.start()
			
			jump_death_called = true





