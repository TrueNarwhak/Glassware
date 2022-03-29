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

var is_attacking = false
var can_attack_boost = true
var landing = true
var motion = Vector2.ZERO
var beachball_count = 0

var jump_death_called = false

onready var sprite = $AnimatedSprite
onready var feet_pos = $FeetPos
onready var ball_aim_pos = $BallAimPos
onready var death_timer = $DeathTimer

# ------------------------------------ #

var inventory = ["floppydisk"]

export var mushroom_force = 800
export var frog_jump = 400
export(PackedScene) var beachball
export(PackedScene) var flower
export(PackedScene) var anvil_stomp
export(PackedScene) var floppy_disk
export var anvil_gravity = 77

# ------------------------------------ #

func ready():
	pass

func _physics_process(delta):
	# Get Inputs
	var x_input = Input.get_action_strength("move_right") - int(jump_death_called) - Input.get_action_strength("move_left")
	var current_jump = JUMP_FORCE + frog_jump*int(inventory.has("frog"))
	
	# Physics
	if x_input != 0:
		motion.x += x_input * ACCELERATION * delta * TARGET_FPS
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		
		sprite.playing = true
		sprite.play("Walk")
		
		if is_on_floor() and !jump_death_called:
			sprite.flip_h = x_input < 0
	else:
		sprite.playing = false
		if is_on_floor():
			sprite.play("default")
	
	# Apply Gravity
	motion.y += GRAVITY * delta * TARGET_FPS
	
	if is_on_floor():
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION * delta)
			
		if Input.is_action_just_pressed("jump"):
			motion.y = -current_jump
		
		if landing:
			landing = false
		
		can_attack_boost = true
	else:
		
		if Input.is_action_just_released("jump") and motion.y < -current_jump/2:
			motion.y = -current_jump/2
		
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta)
		
		if motion.y < 0:
			sprite.play("Jump")
		else:
			sprite.play("Fall")
		
		if !landing:
			landing = true
	
	if jump_death_called:
		sprite.play("Shatter")
	
	# Attacking
	if Input.is_action_just_pressed("attack") and !is_attacking and !jump_death_called:
		is_attacking = true
		
		var this_attack = attack.instance()
		add_child(this_attack)
		
		# Boosting
		if can_attack_boost and !is_on_floor():
			motion = attack_force * get_local_mouse_position().normalized()
			can_attack_boost = false
		
		# Items
		beachball_count += 1
		if beachball_count > 3:
			beachball_count = 0
		
		if inventory.has("seal") and beachball_count == 3:
			var this_beachball = beachball.instance()
			this_beachball.global_position = ball_aim_pos.global_position
			get_parent().add_child(this_beachball)
	
	# Apply physics
	motion = move_and_slide(motion, Vector2.UP)
	
	# Items -------
	# Anvil
	if inventory.has("anvil") and !is_on_floor():
		if Input.is_action_pressed("move_down"):
			motion.y += anvil_gravity * delta * TARGET_FPS
				
#			if landing:
#				var this_anvil_stomp = anvil_stomp.instance()
#				this_anvil_stomp.global_position = get_global_position()
#				get_parent().add_child(this_anvil_stomp)
	
	# Floppy disk
	if inventory.has("floppydisk"):
		if Input.is_action_just_pressed("move_down") and !get_parent().has_node("FloppyDisk"):
			var this_disk = floppy_disk.instance()
			
			this_disk.position = global_position
			get_parent().add_child(this_disk)

func _on_MushroomStomp_body_entered(body):
	if inventory.has("mushroom") and body.get_parent().is_in_group("Enemies") and !is_on_floor():
		body.get_parent().survive -= 1
		print("stomp!")
		motion.y = -mushroom_force

func shatter():
	print("Shxrch!")
	
	if !jump_death_called:
		motion.y = -death_jump
		
		death_timer.start()
		
		jump_death_called = true
	


func _on_WateringCanTimer_timeout():
	if inventory.has("wateringcan") and is_on_floor() and !motion.x == 0:
		var this_flower = flower.instance()
		this_flower.global_position = feet_pos.get_global_position()
		get_parent().add_child(this_flower)


func _on_DeathTimer_timeout():
	set_process(false)
	set_physics_process(false)
	visible = false
	
	for i in 6:
		var this_shard = shard.instance()
		this_shard.position = get_global_position()
		get_tree().get_root().add_child(this_shard)
