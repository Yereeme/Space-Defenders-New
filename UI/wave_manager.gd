extends Node2D

@export var enemy_scene: PackedScene  
@export var mothership_scene: PackedScene  
@export var wave_interval: float = 5.0  # Time between waves in seconds
@export var mothership_spawn_time: float = 30.0  # Time before the mothership spawns
@export var enemies_per_wave: int = 3  # Number of enemies per wave
@export var spawn_position: Vector2 = Vector2(1000, 400)  # Starting position of enemies off-screen

var is_mothership_active: bool = false  # Tracks if the mothership is currently active

func _ready() -> void:
	# Start the wave spawning process
	if not multiplayer.is_server():
		return
	start_wave_spawning()

	# Set a timer for the mothership to spawn
	var mothership_timer = Timer.new()
	mothership_timer.wait_time = mothership_spawn_time
	mothership_timer.one_shot = true
	mothership_timer.autostart = true
	add_child(mothership_timer)
	mothership_timer.timeout.connect(Callable(self, "spawn_mothership"))

func start_wave_spawning() -> void:
	# Loop to spawn waves indefinitely
	while true:
		if not is_mothership_active:
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
	#get_tree().current_scene.call_deferred("add_child", enemy)
	$enem.add_child(enemy, true)

func spawn_mothership() -> void:
	print("Spawning mothership...")
	is_mothership_active = true

	# Instantiate the mothership
	var mothership = mothership_scene.instantiate()
	mothership.position = Vector2(500, 200)  # Adjust the position as needed
	#get_tree().current_scene.call_deferred("add_child", mothership)
	$enem.add_child(mothership, true)

	# Connect to the tree_exited signal to detect when the mothership is removed
	mothership.connect("tree_exited", Callable(self, "_on_mothership_defeated"))

func _on_mothership_defeated() -> void:
	print("Mothership defeated!")
	is_mothership_active = false
