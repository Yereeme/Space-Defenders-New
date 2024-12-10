extends Area2D

var direction := Vector2(1, 0)  # Moves to the right
@export var speed: float = 1000.0  # Speed of the laser

func _process(delta: float) -> void:
	position += direction * speed * delta  # Move the laser

	# Remove the laser if it goes off-screen
	if position.x > get_viewport_rect().size.x:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):  # Check if the laser hits an enemy
		body.take_damage(1)  # Damage the enemy
		queue_free()  # Destroy the laser after hitting
