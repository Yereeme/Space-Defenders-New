extends Powerup
#Thanks to CodeNMore
@export var shieldTime: float = 6


func _on_body_entered(body: Node2D) -> void:
	print("Bullet collided with:", body)  # Debug to verify collision
	if body.is_in_group("players"):  # Check if it hit the player
		body.applyShield()  # Call the player's take_damage function
		queue_free()
