extends Node

func _process(_delta):
	if Input.is_action_just_pressed("Quit Game"):
		get_tree().quit()
	if Input.is_action_just_pressed("FullScreen"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer. WINDOW_MODE_WINDOWED)
