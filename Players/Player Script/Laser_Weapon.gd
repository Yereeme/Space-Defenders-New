extends Node2D

#Youtube Tutorial URL: https://www.youtube.com/watch?v=-UuPEaaZkV0
#Creating Laser Shot

@export var laser_scene: PackedScene = preload("res://Players/Laser.tscn")  # Preload the laser scene

func shoot():
	# Instance the laser
	var laser = laser_scene.instantiate()
	laser.global_position = self.global_position  # Set laser position to the shooter's position
	
	# Add the laser to the current scene (ensure the path is correct)
	get_tree().current_scene.add_child(laser)
