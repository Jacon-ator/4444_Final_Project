extends Node2D   # or whichever root type you’re using

@onready var timer      : Timer = $Timer
@onready var time_label : Label = $Label

func _ready():
	timer.timeout.connect(_on_LevelTimer_timeout)
	
	_update_time_label(timer.time_left)

func _process(delta):
	_update_time_label(timer.time_left)

func _update_time_label(time_left_sec: float) -> void:
	var total_seconds = int(time_left_sec)             
	var seconds = total_seconds % 60                    
	var fraction = time_left_sec - total_seconds      
	var milliseconds = int(fraction * 1000)            

	#timer formatting
	time_label.text = "%02d:%03d" % [seconds, milliseconds]

func _on_LevelTimer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/endscreen.tscn")
