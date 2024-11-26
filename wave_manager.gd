extends Node2D

@export var enemy_scene: PackedScene  # Assign your Enemy.tscn here
@export var wave_interval: float = 5.0  # Time between waves in seconds
@export var enemies_per_wave: int = 3  # Number of enemies per wave
@export var spawn_position: Vector2 = Vector2(1000, 400)  # Starting position of enemies off-screen

func _ready() -> void:
	# Start the wave spawning process
	start_wave_spawning()

func start_wave_spawning() -> void:
	# Loop to spawn waves indefinitely
	while true:
		await spawn_wave()
		await get_tree().create_timer(wave_interval).timeout

func spawn_wave() -> void:
	for i in range(enemies_per_wave):
		spawn_enemy()
		await get_tree().create_timer(1.0).timeout  # 1-second delay between enemy spawns

func spawn_enemy() -> void:
	var enemy = enemy_scene.instantiate()
	# Add slight vertical variation to the spawn position
	enemy.position = spawn_position + Vector2(0, randf_range(-200, 200))
	# Safely add the enemy using call_deferred to avoid setup issues
	get_tree().current_scene.call_deferred("add_child", enemy)
