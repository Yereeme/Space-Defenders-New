class_name Powerup
extends Area2D
#Thanks to CodeNMore
@export var powerupMoveSpeed: float = 10

func _physics_process(delta: float) -> void:
	position.y += powerupMoveSpeed * delta

func applyPowerup(player: Player):
	#This needs to be implemented by the inherited class
	pass

func _on_area_entered(area: Area2D) -> void:
	if area is Players:
		applyPowerup(area)
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
