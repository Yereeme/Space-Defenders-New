extends Node2D

@export var scale_min: float = 0.75
@export var scale_max: float = 1.25

func _ready():
	initial_changes()
	
func initial_changes():
	randomize()
	var new_scale = randf_range(scale_min, scale_max)
	scale = Vector2(new_scale, new_scale)
	rotation = randf() * 360.0

func _on_area_2d_body_entered(_body):
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("HideOne")

func _on_audio_stream_player_finished() -> void:
	get_tree().call_group("powerUp", "")
	queue_free()
