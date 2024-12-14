extends Control
# Youtube tutorials URL: https://www.youtube.com/watch?v=AnlqaEh0jac&list=PLbSahu9sYUErP351x_acLNfnAkRrhZ19D&index=6
# Creating Game Over Scene!
# Youtube tutorials URL: https://www.youtube.com/watch?v=A5LZaTuIK7s&list=PLbSahu9sYUErP351x_acLNfnAkRrhZ19D&index=5
# Creating Final Score and Timer system!

var score: Label

func _ready():
	score = $HighScore
	score.text = "High Score: " + str(Global.score)

func _on_reset_pressed() -> void:
	get_tree().change_scene_to_file("res://Game.tscn")
# Run back to main game scene! "Restart"

func _on_quit_pressed() -> void:
	get_tree().quit()
