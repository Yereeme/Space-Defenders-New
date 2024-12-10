extends Control
# Youtube tutorials URL: 



func _on_reset_pressed() -> void:
	get_tree().change_scene_to_file("res://Game.tscn")
# Run back to main game scene! "Restart"

func _on_quit_pressed() -> void:
	get_tree().quit()
