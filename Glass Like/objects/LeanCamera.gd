# CAMERA BY [redacted] AND GODOT RECIPIES
extends Camera2D

# rumble shake
export var decay = 0.8
export var max_offset = Vector2(100, 75) 
export var max_roll = 0.1 
export var trauma = 0.0 
export var trauma_power = 100

# rotate shake
export var rotate_shake = -4.6
export var rotate_shake_reset = 0.2

# zoom pop
export var zoom_pop = 1.02
export var zoom_reset = 0.05
export var player_death_pop = 1.3

# Zoom in on player
export var zoom_into = Vector2(0.8, 0.8)
export var zoom_in_speed = 0.05

onready var player = get_parent().get_node("Player")

const smooth_lean = 10.0
const scale_lean  = 0.05

# ------------------------------------------------------- #

func _ready():
	randomize()

func _process(delta):
	
#	if player.jump_death_called and player.visible:
#
#		# Zoomed in on death Mode ------------------------------------
#
#		# Match Player Position
#		position = lerp(position, player.position, 0.9)
#
#		# Zoom into player
#		rotation_degrees = lerp(rotation_degrees, 0.0, rotate_shake_reset)
#		zoom = lerp(zoom, zoom_into, zoom_in_speed)
#	else:
#
#		# Tilt Camera Mode  ------------------------------------
#
#		position = lerp(position, Vector2(480.0, 271.0), rotate_shake_reset)
#
#		# Tilt
#		if Options.camera_tilt:
#			lean_camera_towards_mouse_(delta)
#
#		# Reset Rotation
#		rotation_degrees = lerp(rotation_degrees, 0.0, rotate_shake_reset)
#
#		# Reset Zoom
#		zoom = lerp(zoom, Vector2(1.0, 1.0), zoom_reset)
		
		
#		position = lerp(position, Vector2(480.0, 271.0), rotate_shake_reset)
		
		# Tilt
		if Options.camera_tilt:
			lean_camera_towards_mouse_(delta)

		# Reset Rotation
		rotation_degrees = lerp(rotation_degrees, 0.0, rotate_shake_reset)

		# Reset Zoom
		zoom = lerp(zoom, Vector2(1.0, 1.0), zoom_reset)
		
	# *****************************
	# Note to self uhhh fix this maybe??? but also i can imagine it would be too much whiplast considering frequent player deaths. less zoom mayhaps

func lean_camera_towards_mouse_(delta):
	var mouse_position = get_global_mouse_position()
	
	var lean = (mouse_position - position) * scale_lean
	offset = lerp(offset, lean, delta * smooth_lean)

func match_player_position_():
	position = player.position

func shake():
	if Options.screenshake:
		var amount = pow(trauma, trauma_power)
		rotation = max_roll * amount * rand_range(-1, 1)
		offset.x = max_offset.x * amount * rand_range(-1, 1)
		offset.y = max_offset.y * amount * rand_range(-1, 1)
