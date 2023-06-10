extends PathFollow2D

export var gear_turn = 425
export var move_along_path_speed = 0.13

onready var gear = $Kinematicbody/Gear

func _ready():
	pass

func _physics_process(delta):
	gear.rotation_degrees += gear_turn * delta
	
	unit_offset += move_along_path_speed * delta
	
	if unit_offset == 1.0 and move_along_path_speed > 0:
		move_along_path_speed = -move_along_path_speed
	
	if unit_offset == 0.0 and move_along_path_speed < 0:
		move_along_path_speed = -move_along_path_speed
