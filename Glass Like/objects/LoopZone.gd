extends Area2D


func _ready():
	pass


func _on_LoopZone_body_entered(body):
	if body.is_in_group("Player"):
		body.position = Vector2(480, -120)
		print("aaa")
