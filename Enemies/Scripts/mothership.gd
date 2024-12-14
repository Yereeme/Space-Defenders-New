extends CharacterBody2D

# How fast the mothership moves in Phase 2 (up and down)
@export var speed: float = 50.0

# Total health for the mothership
@export var max_health: int = 50  
var current_health: int = max_health

# Reference to the existing bullet scene
@export var bullet_scene: PackedScene  

# Flag to know if Phase 2 is active
var in_phase_2: bool = false  

# Get cannon positions for shooting
@onready var cannon1 = $Cannon1  # Left cannon
@onready var cannon2 = $Cannon2  # Right cannon
@onready var middle_cannon = $MiddleCannon  # Middle cannon for tracking bullets

# Timer variable to control vertical movement smoothly
var time_elapsed: float = 0.0  

func _ready() -> void:
	
	if not multiplayer.is_server():
		return
	# Start the shooting cycle when the mothership spawns
	start_shooting()

	# Position the mothership just at the edge of the screen
	position = Vector2(950, 300)  

func _physics_process(delta: float) -> void:
	if in_phase_2:
		# If we're in Phase 2, make the mothership move up and down smoothly
		phase_2_movement(delta)

func take_damage(amount: int) -> void:
	# Reduce health when hit
	current_health -= amount
	print("Boss hit! Remaining health:", current_health)

	if current_health <= max_health / 2 and not in_phase_2:
		# When health drops below half, go into Phase 2
		start_phase_2()

	if current_health <= 0:
		# If health is zero, destroy the boss
		die()

func start_phase_2() -> void:
	# Start Phase 2 behavior
	in_phase_2 = true
	print("Boss entering Phase 2!")

func die() -> void:
	$AnimatedSprite2D.play("defeated")
	# Remove the mothership when defeated
	print("Boss defeated!")
	if current_health <= 0:
		get_tree().change_scene_to_file("res://Win.tscn")
		queue_free()

func start_shooting() -> void:
	# Set up a timer to shoot bullets periodically
	var attack_timer = Timer.new()
	attack_timer.wait_time = 1.5  # Fire every 1.5 seconds
	attack_timer.autostart = true
	attack_timer.one_shot = false
	add_child(attack_timer)
	attack_timer.timeout.connect(Callable(self, "_perform_attack"))
	

func _perform_attack() -> void:
	# Randomly pick an attack type
	var attack_type = randi() % 3  
	if attack_type == 0:
		shoot_normal_bullets()
	elif attack_type == 1:
		shoot_cone_bullets()
	elif attack_type == 2:
		shoot_tracking_bullet()

func shoot_normal_bullets() -> void:
	# Shoot normal bullets from the left and right cannons
	spawn_bullet(cannon1.global_position, Vector2.LEFT)
	spawn_bullet(cannon2.global_position, Vector2.LEFT)

func shoot_cone_bullets() -> void:
	# Shoot bullets in a cone formation (spread out)
	for angle in [-30, -15, 0, 15, 30]:  # Angles to spread the bullets
		var direction = Vector2(cos(deg_to_rad(angle)), sin(deg_to_rad(angle)))
		direction.x *= -1  # Flip the x-axis to shoot toward the left
		spawn_bullet(middle_cannon.global_position, direction)

func shoot_tracking_bullet() -> void:
	# Shoot a bullet that follows the player
	spawn_bullet(middle_cannon.global_position, Vector2.ZERO, true)

func spawn_bullet(position: Vector2, direction: Vector2 = Vector2.ZERO, is_tracking: bool = false) -> void:
	var bullet = bullet_scene.instantiate()  # Create a new bullet instance
	bullet.position = position  # Set the bullet's position
	bullet.direction = direction  # Set the bullet's direction

	# Add the bullet to the "pew" node if it exists
	if $mothershell:
		$mothershell.add_child(bullet, true)  # Add the bullet to the "pew" container
		print("Bullet added to pew at position:", position)
	else:
		print("Error: pew node not found! Adding bullet to current scene.")
		if get_tree().current_scene:
			get_tree().current_scene.add_child(bullet)  # Fallback to adding bullet to the current scene
		else:
			print("Error: No valid parent to add bullet!")



	

func phase_2_movement(delta: float) -> void:
	# Make the mothership move up and down more dramatically in Phase 2
	time_elapsed += delta
	velocity.y = sin(time_elapsed * 2.0) * (speed + 20)  # Speed up movement a bit
	move_and_slide()
