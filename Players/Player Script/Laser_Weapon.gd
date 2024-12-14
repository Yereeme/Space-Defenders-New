extends Node2D

@export var laser_scene: PackedScene = preload("res://Players/Laser.tscn")  # Preload the laser scene

@onready var gun = $gun  # Reference to the "gun" node

@rpc("call_remote")
func shoot():
	# Instance the laser
	var laser = laser_scene.instantiate()
	laser.global_position = self.global_position  # Set laser position to the shooter's position

	# Add the laser to the "gun" node if it exists
	if gun:
		gun.add_child(laser)
		print("Laser added to gun at position:", laser.global_position)
	else:
		print("Error: gun node not found! Adding laser to current scene.")
		if get_tree().current_scene:
			get_tree().current_scene.add_child(laser)  # Fallback to adding laser to the current scene
		else:
			print("Error: No valid parent to add laser!")

	# Assign multiplayer authority
	if laser.has_node("MultiplayerSynchronizer"):
		laser.get_node("MultiplayerSynchronizer").set_multiplayer_authority(multiplayer.get_unique_id())

	# Synchronize bullet spawning across all peers
	rpc("shoot")


	 
