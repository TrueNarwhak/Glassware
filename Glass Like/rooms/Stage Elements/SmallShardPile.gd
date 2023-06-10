extends StaticBody2D

var bounce_sounds = [
	load("res://sound/sfx/impact soft heavy/impactSoft_heavy_000.ogg"), 
	load("res://sound/sfx/impact soft heavy/impactSoft_heavy_001.ogg"), 
	load("res://sound/sfx/impact soft heavy/impactSoft_heavy_002.ogg"), 
	load("res://sound/sfx/impact soft heavy/impactSoft_heavy_003.ogg"), 
	load("res://sound/sfx/impact soft heavy/impactSoft_heavy_004.ogg")
]

onready var bounce_sfx = $BounceSFX

func _on_Area2D_body_entered(body):
	if(body.is_in_group("Player") or body.is_in_group("Enemies")):
		if(body.motion.y >=-0.1):
			body.motion.y += 1
			body.motion = (-body.motion * 1.3)
			# Sound
			bounce_sfx.stream = bounce_sounds[randi() % bounce_sounds.size()]
			bounce_sfx.play()
		
	
	
	
