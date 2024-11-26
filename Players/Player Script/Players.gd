extends CharacterBody2D

const max_speed = 400
const accel = 1500
const friction = 600

var input = Vector2.ZERO

# Player health
@export var max_health: int = 3  # Maximum health of the player
var current_health: int = max_health  # Tracks current health

# Reference to the Lives node in the UI
@onready var lives_ui = $"../Lives" # Adjust this path to point to your Lives node

func _ready() -> void:
	current_health = max_health  # Initialize player health
	update_lives_ui()  # Ensure the UI matches the player's starting health

func _physics_process(delta: float) -> void:
	player_movement(delta)

func get_input() -> Vector2:
	input.x = int(Input.is_action_pressed("Right")) - int(Input.is_action_pressed("Left"))
	input.y = int(Input.is_action_pressed("Down")) - int(Input.is_action_pressed("Up"))
	return input.normalized()

func player_movement(delta: float) -> void:
	input = get_input()
	if input == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
	else: 
		velocity += (input * accel * delta)
		velocity = velocity.limit_length(max_speed)
	move_and_slide()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("Shoot"):
		$LaserWeapon.shoot()  # Call the shoot function

# Handle taking damage from enemy bullets
func take_damage(amount: int) -> void:
	current_health -= amount
	print("Player hit! Remaining health:", current_health)  # Debugging message
	update_lives_ui()  # Update the UI to reflect the remaining lives

	if current_health <= 0:
		print("Player is dead!")
		queue_free()  # Remove the player when health is 0

# Update the UI to reflect the player's remaining lives
func update_lives_ui() -> void:
	for i in range(lives_ui.get_child_count()):
		var life_icon = lives_ui.get_child(i)
		if i < current_health:
			life_icon.visible = true  # Show life icons for remaining health
		else:
			life_icon.visible = false  # Hide life icons for lost health
