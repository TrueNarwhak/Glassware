# CAMERA 
extends Camera2D

const smooth_lean := 10.0
const scale_lean  := 0.05

func lean_camera_towards_mouse_(delta:float) -> void:
	var mouse_position := get_global_mouse_position()
	
	var lean := (mouse_position - position) * scale_lean
	offset = lerp(offset, lean, delta * smooth_lean)

func match_player_position_() -> void:
	position = get_node("../Player").position

func _process(delta) -> void:
	if Options.camera_tilt:
		lean_camera_towards_mouse_(delta)
