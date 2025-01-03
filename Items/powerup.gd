class_name Powerup
extends Area2D
#Thanks to CodeNMore
@export var powerupMoveSpeed: float = 10
@onready var spawn_points = []

func _physics_process(delta: float) -> void:
	position.y += powerupMoveSpeed * delta

func create_collectable():
	if spawn_points.size() == 0:
		return
		
	var spawn_point = spawn_points[randi() % spawn_points.size()]
	var new_collectible = shield_powerup_scene.instantiate()
	add_child(new_collectible)
	new_collectible.position = spawn_point.position

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("players"):
		area.applyShield(area)
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
