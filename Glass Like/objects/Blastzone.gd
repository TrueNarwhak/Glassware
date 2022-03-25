extends Enemy


func _ready():
	pass


func _on_Blastzone_body_entered(body):
	var this_body = body.get_parent()
	
	if body.is_in_group("Player"):
		body.shatter()
	
	if this_body.is_in_group("Enemies"):
		if this_body.get_parent().get_parent().get_global_position().x == 0:
			this_body.survive -= 1
	
	if body.is_in_group("Projectile") or body.is_in_group("Beachball"):
		body.queue_free()
