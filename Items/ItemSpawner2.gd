extends Node
@export var max_Items2: int = 25
@onready var invisibility_scene = preload("res://Items/invisibility.tscn")
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
	
func create_Items2():
	randomize()
	var x_pos: float = randf_range(x_min, x_max)
	var y_pos: float = randf_range(y_min, y_max)
	var new_invisibility = invisibility_scene.instantiate()
	add_child(new_invisibility)
	new_invisibility.position =Vector2(x_pos, y_pos)

func spawn_multiple():
	for n in max_Items2:
		create_Items2()


func _on_timer_timeout() -> void:
	create_Items2()
