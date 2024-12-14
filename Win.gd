extends Control

var score: Label

func _ready():
	score = $HighScore
	score.text = "High Score: " + str(Global.score)

func resume():
	get_tree().paused = false

func _on_resume_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://Game.tscn")
# Run back to main game scene! "Restart"

func _on_quit_pressed() -> void:
	get_tree().quit()
