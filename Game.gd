extends Node2D
class_name Game

@export var stopwatch_label : Label

var stopwatch : Stopwatch

func _process(delta):
	update_stopwatch_label()

func _ready():
	stopwatch = get_tree().get_first_node_in_group("Stopwatch")

func update_stopwatch_label():
	stopwatch_label.text = stopwatch.time_to_string()
