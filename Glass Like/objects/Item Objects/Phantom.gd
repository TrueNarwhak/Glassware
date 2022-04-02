extends Area2D

export var enemy_follow_speed = 10
export var player_follow_speed = 10
export var flicker_speed = 0.4

var evil = false

onready var sprite = $AnimatedSprite
onready var player = get_node("Player")

func _ready():
	randomize()

func _process(delta):
	
	if !evil:
		# Anim
		var flicker_current = rand_range(0.4, 1)
		modulate.a = lerp(modulate.a, flicker_current, flicker_speed)
		
		# Attack Target
#		var enemies = get_node()("space_stations")
#
#		var nearest_spawn_point = spawn_points[0]
#
#		for spawn_point in spawn_points:
#			if spawn_point.global_position.distance_to(player.global_position) < nearest_spawn_point.global_position.distance_to(player.global_position):
#				nearest_spawn_point = spawn_point
#
#	    # reposition player
#		global_position = nearest_spawn_point.global_position
