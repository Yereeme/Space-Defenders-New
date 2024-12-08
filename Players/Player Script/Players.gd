extends CharacterBody2D
#Partly thanks to CodeNMore
const max_speed = 400
const accel = 1500
const friction = 600

var input = Vector2.ZERO

@export var speed: float = 500.0

# Player health
@export var max_health: int = 3  # Maximum health of the player
var current_health: int = max_health  # Tracks current health

# Reference to the Lives node in the UI
var lives_ui: Node = null

# Set by the authority, synchronized on spawn.
@export var player := 1:
	set(id):
		player = id
		# Give authority over the player input to the appropriate peer.
		$InputSynchronizer.set_multiplayer_authority(id)

# Player synchronized input.
@onready var input_sync = $InputSynchronizer
@onready var invincibilityTimer = $InvincibilityTimer
@onready var shieldSprite = $Shield

@export var damagedInvincibilityTime = 2.0

func _ready() -> void:
	shieldSprite.visible = false
	# Assign the Lives node
	lives_ui = get_node_or_null("../Lives")  # Adjust this path to match your scene
	if lives_ui == null:
		print("Error: Lives UI node not found! Check the path.")
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
		$Lasers.shoot()  # Call the shoot function

# Handle taking damage from enemy bullets
func take_damage(amount: int) -> void:
	if !invincibilityTimer.is_stopped():
		return
	
	applyShield(damagedInvincibilityTime)
	current_health -= amount
	print("Player hit! Remaining health:", current_health)  # Debugging message
	update_lives_ui()  # Update the UI to reflect the remaining lives

	if current_health <= 0:
		get_tree().change_scene_to_file("res://Game Over.tscn")
		print("Player is dead!")
		queue_free()  # Remove the player when health is 0

# Update the UI to reflect the player's remaining lives
func update_lives_ui() -> void:
	if lives_ui == null:
		print("Error: Cannot update Lives UI. Lives node is not assigned!")
		return

	for i in range(lives_ui.get_child_count()):
		var life_icon = lives_ui.get_child(i)
		if i < current_health:
			life_icon.visible = true  # Show life icons for remaining health
		else:
			life_icon.visible = false  # Hide life icons for lost health

func applyShield(time: float):
	invincibilityTimer.start(time)
	shieldSprite.visible = true

func _on_invincibility_timer_timeout() -> void:
	shieldSprite.visible = false
