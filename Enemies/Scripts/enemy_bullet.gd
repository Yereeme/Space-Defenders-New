extends Area2D

@export var speed: float = 200.0  # Speed of the bullet
var direction: Vector2 = Vector2.LEFT  # Default direction

func _ready() -> void:
	
	pass

func _physics_process(delta: float) -> void:
	# Update the position manually based on speed and direction
	position += direction * speed * delta

	# Remove the bullet if it goes off-screen
	if position.x < 0 or position.x > get_viewport_rect().size.x:
		queue_free()

func _on_body_entered(body: Node) -> void:
	print("Shield collided with:", body)  # Debug to verify collision
	if body.is_in_group("players"):  # Check if it hit the player
		body.take_damage(1)  # Call the player's take_damage function
		queue_free()  # Destroy the bullet after hitting the player
