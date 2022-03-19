extends Camera2D

onready var y_max_pos = $Node2D/TopMaxPos
onready var y_min_pos = $Node2D/TopMinPos
onready var x_max_pos = $Node2D/XMaxPos
onready var x_min_pos = $Node2D/XMinPos

export var speed = 0.5

# ----------------------------------------- #

func _ready():
	pass

func _process(delta):
	position = lerp(position, get_global_mouse_position(), 0.01)
##
#	position.x = clamp(position.x, x_min_pos.get_global_position().x, x_max_pos.get_global_position().x)
#	position.y = clamp(position.y, y_min_pos.get_global_position().y, y_max_pos.get_global_position().y)

	position.x = clamp(position.x, 384, 576)

	
