extends PathFollow2D

export var gear_turn = 6
export var move_along_path_speed = 0.002

onready var gear = $RigidBody2D/Gear

func _ready():
	pass

func _process(delta):
	gear.rotation_degrees += gear_turn
	
	unit_offset += move_along_path_speed
	
	if unit_offset == 1.0 and move_along_path_speed > 0:
		move_along_path_speed = -move_along_path_speed
	
	if unit_offset == 0.0 and move_along_path_speed < 0:
		move_along_path_speed = -move_along_path_speed
