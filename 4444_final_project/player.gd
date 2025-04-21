extends CharacterBody2D

const tile_size = 32
const move_speed = 0.35
var moving = false
var input_dir

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	# Sets input direction to zero
	input_dir = Vector2.ZERO
	
	# Sets each direction to the approporiate vec2
	if Input.is_action_pressed("ui_down"):
		input_dir = Vector2(0,1)
		move()
	elif Input.is_action_pressed("ui_up"):
		input_dir = Vector2(0,-1)
		move()
	elif Input.is_action_pressed("ui_right"):
		input_dir = Vector2(1, 0)
		move()
	elif Input.is_action_pressed("ui_left"):
		input_dir = Vector2(-1, 0)
		move()
	
# Function for grid based movement
func move():
	if input_dir:
		if moving == false:
			moving = true
			var tween = create_tween()
			tween.tween_property(self, "position", position + input_dir*tile_size, move_speed)
			tween.tween_callback(move_false)
			
# Sets moving to false
func move_false():
	moving = false
	
	
	
	
