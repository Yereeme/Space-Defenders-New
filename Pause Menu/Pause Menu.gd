extends Control
# Youtube Tutorials URl: https://www.youtube.com/watch?v=e9-WQg1yMCY&list=PLbSahu9sYUErP351x_acLNfnAkRrhZ19D&index=3

func _ready():
	$AnimationPlayer.play("RESET")

func resume():
	get_tree().paused = false 
	$AnimationPlayer.play_backwards("Blur")

func pause():
	get_tree().paused = true 
	$AnimationPlayer.play("Blur")

func TestPauseMenu():
	if Input.is_action_just_pressed("Pause Game") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("Pause Game") and get_tree().paused:
		resume()

func _on_resume_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://Game.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _process(delta):
	TestPauseMenu()
