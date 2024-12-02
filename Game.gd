extends Node2D

func _exit_tree():
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_player)


func add_player(id):
	var character = preload("res://Players/Players.tscn").instantiate()
	# Set player id.
	character.player = id
	# Randomize character position.
	character.position = Vector2(randf()*100.0, randf()*100.0)
	character.name = str(id)
	$"Player 2".add_child(character, true)
	
func del_player(id):
	if not $"Player 2".has_node(str(id)):
		return
	$"Player 2".get_node(str(id)).queue_free()
