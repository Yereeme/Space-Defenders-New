extends Node
# Youtube Tutorial URL: https://www.youtube.com/watch?v=HrBjzSqEpwE&t=554s 
#Creating speed run timing system 

class_name Stopwatch

var time = 0.0
# This where time goes up 
var stopped = false 

func _process(delta):
	if stopped: 
		return 
	time += delta

func reset():
	time = 0.0

func time_to_string() -> String:
	# Turn the time var into a string for the UI display!
	var msec = fmod(time, 1) * 1000
	var sec = fmod(time, 60) 
	var min = time / 60
	# formating time to look like this 00:00:000
	var format_string = "%02d : %02d : %02d"
	var actual_string = format_string % [min, sec, msec]
	return actual_string
