extends CharacterBody2D

signal killed

@export var speed: float = 100.0  # Speed of the enemy
@export var bullet_scene: PackedScene = preload("res://Enemies/enemy_bullet.tscn")
@export var shooting_interval: float = 1.5  # Time between shots in seconds
var health: int = 1  # Enemies die after one hit

func _ready() -> void:
	# Create a timer to handle shooting
	var shooting_timer = Timer.new()
	shooting_timer.wait_time = shooting_interval
	shooting_timer.autostart = true
	shooting_timer.one_shot = false
	add_child(shooting_timer)
	shooting_timer.timeout.connect(Callable(self, "_on_shooting_timer_timeout"))

func _physics_process(delta: float) -> void:
	velocity = Vector2(-speed, 0)  # Move the enemy leftward
	move_and_slide()

func _on_shooting_timer_timeout() -> void:
	# Spawn a new bullet
	var bullet = bullet_scene.instantiate()
	bullet.position = $Muzzle.global_position  # Spawn bullet from the muzzle
	bullet.direction = Vector2.LEFT  # Set bullet direction to left
	get_tree().current_scene.add_child(bullet)  # Add bullet to the current scene

# Handle taking damage from player bullets
func take_damage(amount: int) -> void:
	health -= amount
	print("Enemy hit! Remaining health:", health)
	if health <= 0:
		Global.score += 100
		print("Enemy shot! Score: ", Global.score)
		# Scoring System when enemy is killed on scene
		queue_free()  # Remove the enemy from the scene
