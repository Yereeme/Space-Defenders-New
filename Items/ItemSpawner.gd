extends Node
@export var max_Items: int = 25
@onready var extra_lives_scene = preload("res://Items/extra_lives.tscn")
var x_min: float = 0.0
var x_max: float
var y_min: float = 0.0
var y_max: float 

func _ready():
	get_dimenstions()
	spawn_multiple()
	
func get_dimenstions():
	x_max = DisplayServer.window_get_size().x
	y_max = DisplayServer.window_get_size().y
	
func create_Items():
	randomize()
	var x_pos: float = randf_range(x_min, x_max)
	var y_pos: float = randf_range(y_min, y_max)
	var new_extra_lives = extra_lives_scene.instantiate()
	add_child(new_extra_lives)
	new_extra_lives.position =Vector2(x_pos, y_pos)

func spawn_multiple():
	for n in max_Items:
		create_Items()


func _on_timer_timeout() -> void:
	create_Items()
