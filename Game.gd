extends Node2D
class_name Game

@export var stopwatch_label : Label


var stopwatch : Stopwatch

func _process(delta):
	update_stopwatch_label()

func _ready():
	stopwatch = get_tree().get_first_node_in_group("Stopwatch")
	
	if not multiplayer.is_server():
		return

	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)

	# Spawn already connected players
	for id in multiplayer.get_peers():
		add_player(id)

	# Spawn the local player unless this is a dedicated server export.
	if not OS.has_feature("dedicated_server"):
		add_player(1)

func update_stopwatch_label():
	stopwatch_label.text = stopwatch.time_to_string()

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
	$"Player 1".add_child(character, true)
	
func del_player(id):
	if not $"Player 1".has_node(str(id)):
		return
	$"Player 1".get_node(str(id)).queue_free()
