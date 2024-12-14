extends Node2D
class_name Game

@export var stopwatch_label : Label

@onready var pb = $ParallaxBackground

var stopwatch : Stopwatch
var scroll_speed = 100

func _process(delta):
	update_stopwatch_label()
	
	pb.scroll_offset.x += delta*scroll_speed 
	if pb.scroll_offset.x >= 960:
		pb.scroll_offset.x = 0
	print(pb.scroll_offset.x)

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
	var character = preload("res://Players/Player.tscn").instantiate()
	# Set player id.
	character.player = id
	# Randomize character position.
	character.position = Vector2(randf()*100.0, randf()*100.0)
	character.name = str(id)
	$Player.add_child(character, true)
	
func del_player(id):
	if not $Player.has_node(str(id)):
		return
	$Player.get_node(str(id)).queue_free()
