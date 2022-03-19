extends Enemy


func _ready():
	pass


func _on_Blastzone_body_entered(body):
	if body.is_in_group("Player") or body.is_in_group("Enemies"):
		body.shatter()
	
	if body.is_in_group("Projectile") or body.is_in_group("Beachball"):
		body.queue_free()
