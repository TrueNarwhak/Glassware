extends Node2D

var volume_ticks = 5
var volume_sets = [-80, -40, -25, -10, 0]

func _ready():
	pass

func _process(delta):
	
	if Volume.current_volume == 0:
		$VolumeIcon/bar.show()
		$VolumeIcon/bar2.show()
	else:
		$VolumeIcon/bar.hide()
	
	if Volume.current_volume == 1:
		$VolumeIcon/bar.show()
		$VolumeIcon/bar2.show()
		$VolumeIcon/bar3.show()
	else:
		$VolumeIcon/bar2.hide()
	
	if Volume.current_volume == 2:
		$VolumeIcon/bar.show()
		$VolumeIcon/bar2.show()
		$VolumeIcon/bar3.show()
		$VolumeIcon/bar4.show()
	else:
		$VolumeIcon/bar3.hide()
	
	if Volume.current_volume == 3:
		$VolumeIcon/bar.show()
		$VolumeIcon/bar2.show()
		$VolumeIcon/bar3.show()
		$VolumeIcon/bar4.show()
		$VolumeIcon/bar5.show()
	else:
		$VolumeIcon/bar4.hide()
		
	if Volume.current_volume == 4:
		$VolumeIcon/bar.show()
		$VolumeIcon/bar2.show()
		$VolumeIcon/bar3.show()
		$VolumeIcon/bar4.show()
		$VolumeIcon/bar5.show()
	else:
		$VolumeIcon/bar5.hide()
	
	
	if Input.is_action_just_pressed("vol_up"):
		Volume.current_volume += 1
		$AnimationPlayer.stop()
		$AnimationPlayer.play("Volume")
	
	if Input.is_action_just_pressed("vol_down"):
		Volume.current_volume -= 1
		$AnimationPlayer.stop()
		$AnimationPlayer.play("Volume")
	
	Volume.current_volume = clamp(Volume.current_volume, 0, 4)
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume_sets[Volume.current_volume])
	
